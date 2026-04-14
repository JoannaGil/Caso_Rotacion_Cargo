

# =========================================================
# HOARAS EXTRAS / ROTACION 
# =========================================================

tabla_horas <- data %>%
  count(horas_extra, rotacion) %>%
  group_by(horas_extra) %>%
  mutate(prop = n / sum(n) * 100) %>%
  ungroup()

#tabla_horas

no_rot <- tabla_horas %>%
  filter(rotacion == 0) %>%
  pull(prop)

si_rot <- tabla_horas %>%
  filter(rotacion == 1) %>%
  pull(prop)

# =========================================================
# SATISFACCION LABORAL  / ROTACION 
# =========================================================

# Tabla de proporciones
tabla_sat <- prop.table(
  table(data$satisfaccion_laboral_num, data$rotacion),
  1
) * 100

# Extraer datos
categorias <- rownames(tabla_sat)
no_rot <- as.numeric(tabla_sat[, "0"])
si_rot <- as.numeric(tabla_sat[, "1"])

# =========================================================
# CARGO  / ROTACION 
# =========================================================

# Tabla de proporciones
tabla_cargo <- prop.table(
  table(data$cargo_grupo, data$rotacion),
  1
) * 100

# Extraer datos
categorias <- rownames(tabla_cargo)
no_rot <- as.numeric(tabla_cargo[, "0"])
si_rot <- as.numeric(tabla_cargo[, "1"])

# =========================================================
# VIAJE DE NEGOCIOS  / ROTACION 
# =========================================================

df_viaje <- data %>%
  count(viaje_de_negocios, rotacion) %>%
  mutate(
    rotacion_label = ifelse(rotacion == 0, "No rotación", "Sí rotación")
  )


viaje_levels <- levels(data$viaje_de_negocios)

no_rot <- df_viaje %>%
  filter(rotacion_label == "No rotación") %>%
  arrange(viaje_de_negocios) %>%
  pull(n)

si_rot <- df_viaje %>%
  filter(rotacion_label == "Sí rotación") %>%
  arrange(viaje_de_negocios) %>%
  pull(n)

# =========================================================
# LOG_INGRESOS  / ROTACION 
# =========================================================

# Estadísticos por grupo
stats_0 <- boxplot.stats(data$log_ingresos[data$rotacion == 0])
stats_1 <- boxplot.stats(data$log_ingresos[data$rotacion == 1])

# Medias
media_0 <- mean(data$log_ingresos[data$rotacion == 0], na.rm = TRUE)
media_1 <- mean(data$log_ingresos[data$rotacion == 1], na.rm = TRUE)

# Medianas
mediana_0 <- stats_0$stats[3]
mediana_1 <- stats_1$stats[3]

# =========================================================
# ANTIGUEDAD_CARGO  / ROTACION 
# =========================================================
#BOXPLOT
# Estadísticos por grupo
stats_0 <- boxplot.stats(data$antiguedad_cargo[data$rotacion == 0])
stats_1 <- boxplot.stats(data$antiguedad_cargo[data$rotacion == 1])

# Medias
media_0 <- mean(data$antiguedad_cargo[data$rotacion == 0], na.rm = TRUE)
media_1 <- mean(data$antiguedad_cargo[data$rotacion == 1], na.rm = TRUE)

# Medianas
mediana_0 <- stats_0$stats[3]
mediana_1 <- stats_1$stats[3]

#BARRAS

data <- data %>%
  mutate(
    antiguedad_grupo = case_when(
      antiguedad_cargo <= 1 ~ "0-1 años",
      antiguedad_cargo <= 3 ~ "2-3 años",
      antiguedad_cargo <= 5 ~ "4-5 años",
      TRUE ~ "6+ años"
    )
  )

data$antiguedad_grupo <- factor(
  data$antiguedad_grupo,
  levels = c("0-1 años", "2-3 años", "4-5 años", "6+ años")
)
tabla_ant <- prop.table(
  table(data$antiguedad_grupo, data$rotacion),
  1
) * 100

categorias <- rownames(tabla_ant)
no_rot <- as.numeric(tabla_ant[, "0"])
si_rot <- as.numeric(tabla_ant[, "1"])


