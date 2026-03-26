
# ANALYSE DES EPISODES ORAGEUX AUTOUR DES AEROPORTS


# Chargement des librairies nécessaires
library(dplyr)      # manipulation des données
library(lubridate)  # gestion des dates
library(ggplot2)    # visualisation

# Importation du jeu de données
data <- read.csv("segment_alerts_all_airports_train.csv")

# Visualisation rapide de la structure des données
View(data)
head(data)

# Conversion de la variable date en format temporel exploitable
data$date <- ymd_hms(data$date)

############################################################
# CONSTRUCTION D’UN JEU DE DONNEES AU NIVEAU DES ORAGES
############################################################

# Agrégation des éclairs par aéroport et par alerte
storm_data <- data %>%
  filter(!is.na(airport_alert_id)) %>%   # on garde uniquement les éclairs associés à une alerte
  group_by(airport, airport_alert_id) %>% # définition d’un épisode orageux
  summarise(
    start_time   = min(date, na.rm = TRUE),  # début de l’orage
    end_time     = max(date, na.rm = TRUE),  # fin de l’orage
    
    # durée totale de l’orage en minutes
    duration_min = as.numeric(difftime(end_time, start_time, units = "mins")),
    
    # intensité électrique
    n_lightning  = n(),                      # nombre total d’éclairs
    
    # structure spatiale
    dist_mean    = mean(dist, na.rm = TRUE), # distance moyenne à l’aéroport
    dist_sd      = sd(dist, na.rm = TRUE),   # dispersion spatiale
    
    # énergie électrique
    amp_mean     = mean(amplitude, na.rm = TRUE), 
    amp_max      = max(abs(amplitude), na.rm = TRUE),
    
    # dispersion directionnelle
    azimuth_sd   = sd(azimuth, na.rm = TRUE),
    
    .groups = "drop"
  )

############################################################
# PREPARATION DES DONNEES POUR LE CLUSTERING
############################################################

# Sélection uniquement des variables quantitatives
storm_num <- storm_data %>%
  select(duration_min, n_lightning, dist_mean, dist_sd,
         amp_mean, amp_max, azimuth_sd)

# Remplacement des valeurs manquantes de dispersion
storm_num$dist_sd[is.na(storm_num$dist_sd)] <- 0
storm_num$azimuth_sd[is.na(storm_num$azimuth_sd)] <- 0

# Standardisation des variables (centrage-réduction)
storm_scaled <- scale(storm_num)

# Nombre d’épisodes orageux
nrow(storm_scaled)

############################################################
# CLUSTERING NON SUPERVISE (K-MEANS)
############################################################

set.seed(123)   # reproductibilité

# Nombre de clusters fixé à 3 (ou moins si peu d’observations)
k <- min(3, nrow(storm_scaled))

# Application de l’algorithme K-means
kmeans_res <- kmeans(storm_scaled, centers = k)

# Attribution du cluster à chaque épisode
storm_data$cluster <- kmeans_res$cluster

# Taille des clusters
table(storm_data$cluster)

############################################################
# ANALYSE DES CARACTERISTIQUES MOYENNES PAR CLUSTER
############################################################

storm_data %>%
  group_by(cluster) %>%
  summarise(
    duration = mean(duration_min),     # durée moyenne
    n_flash  = mean(n_lightning),      # intensité moyenne
    dist     = mean(dist_mean),        # distance moyenne
    amp      = mean(amp_mean),         # amplitude moyenne
    dispersion = mean(azimuth_sd)      # dispersion directionnelle
  )

############################################################
# VISUALISATION DES CLUSTERS
############################################################

ggplot(storm_data, aes(duration_min, n_lightning,
                       color = factor(cluster))) +
  geom_point(size = 2) +
  theme_minimal() +
  labs(
    title = "Typologie des épisodes orageux",
    x = "Durée de l’orage (minutes)",
    y = "Nombre d’éclairs",
    color = "Cluster"
  )

############################################################
# REPARTITION DES TYPES D’ORAGES PAR AEROPORT
############################################################

table(storm_data$airport, storm_data$cluster)
