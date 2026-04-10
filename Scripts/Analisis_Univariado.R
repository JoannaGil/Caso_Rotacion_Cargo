

# -----------------------------------------------------------------------------
# 0. LIBRERÍAS REQUERIDAS
# -----------------------------------------------------------------------------

library(ggplot2)
library(summarytools)
library(janitor)
library(skimr)
library(highcharter)



# -----------------------------------------------------------------------------
#  UNIVARIADO 
# -----------------------------------------------------------------------------
# =========================
#  VARIABLES NUMÉRICAS
# =========================
# =========================
#  INGRESOS MENSUALES
# =========================





# =========================================================
# 1) PARTE REUTILIZABLE
# =========================================================

crear_boxplot_highcharter <- function(x, nombre_categoria = "Variable", titulo = "Boxplot") {
  
  # Quitar NA
  x <- x[!is.na(x)]
  
  # Estadísticos del boxplot
  bp <- boxplot.stats(x)
  stats <- bp$stats
  outliers <- bp$out
  
  # Estructura que necesita Highcharts:
  # [mínimo, Q1, mediana, Q3, máximo]
  box_data <- list(list(
    low = stats[1],
    q1 = stats[2],
    median = stats[3],
    q3 = stats[4],
    high = stats[5]
  ))
  
  # Outliers como puntos scatter
  outlier_data <- lapply(outliers, function(valor) {
    list(x = 0, y = valor)
  })
  
  highchart() %>%
    hc_chart(type = "boxplot") %>%
    hc_title(text = titulo) %>%
    hc_xAxis(categories = c(nombre_categoria)) %>%
    hc_yAxis(title = list(text = nombre_categoria)) %>%
    hc_add_series(
      name = nombre_categoria,
      data = box_data
    ) %>%
    hc_add_series(
      type = "scatter",
      name = "Atipicos",
      data = outlier_data,
      marker = list(fillColor = "#B2DF8A"),
      tooltip = list(pointFormat = "Atipicos: {point.y}")
    ) %>%
    hc_tooltip(
      useHTML = TRUE,
      pointFormat = paste0(
        "<b>Mínimo:</b> {point.low}<br>",
        "<b>Q1:</b> {point.q1}<br>",
        "<b>Mediana:</b> {point.median}<br>",
        "<b>Q3:</b> {point.q3}<br>",
        "<b>Máximo:</b> {point.high}"
      )
    )
}








# 
# #Bivariado Salario 
# boxplot_highcharter(
#   data = data,
#   variable = log_ingresos,
#   titulo = "Log de ingresos según rotación",
#   etiqueta_y = "Log del ingreso mensual"
# )

# =========================
# PREPARAR DATOS

ingresos <- data$ingreso_mensual

# Crear cortes para el histograma
hist_data <- hist(ingresos, plot = FALSE, breaks = 20)

# Data frame
df_hist_ingreso <- data.frame(
  xmin = hist_data$breaks[-length(hist_data$breaks)],
  xmax = hist_data$breaks[-1],
  frecuencia = hist_data$counts
) %>%
  mutate(
    rango = paste0(round(xmin, 0), " - ", round(xmax, 0))
  )

#La variable de ingresos tiene una distribucion sesgada positivamente por lo que trabajaremos esta varibele en (LOG).

data$log_ingresos <- log(data$ingreso_mensual + 1)

#---------------------------------------------------------------------------------

# =========================
# ANTIGUEDAD
# =========================

antig <- data$antiguedad

# Crear histograma base
hist_data <- hist(antig, plot = FALSE, breaks = 15)

# Data frame
df_hist_antig <- data.frame(
  xmin = hist_data$breaks[-length(hist_data$breaks)],
  xmax = hist_data$breaks[-1],
  frecuencia = hist_data$counts
) %>%
  mutate(
    rango = paste0(round(xmin, 1), " - ", round(xmax, 1), " años")
  )


# =========================
# AÑOS A CARGO DEL MISMO JEFE
# =========================

valores <- data$anos_acargo_con_mismo_jefe

hist_data <- hist(valores, plot = FALSE, breaks = 10)

df <- data.frame(
  xmin = hist_data$breaks[-length(hist_data$breaks)],
  xmax = hist_data$breaks[-1],
  frecuencia = hist_data$counts
)

df$rango <- paste0(round(df$xmin, 1), " - ", round(df$xmax, 1))



# =========================
# HORAS EXTRAS
# =========================

df_hextra <- data %>%
  count(horas_extra, rotacion) %>%
  mutate(
    rotacion_label = ifelse(rotacion == 0, "No rotación", "Sí rotación")
  )

# Extraer datos
no_rot <- df_hextra %>%
  filter(rotacion_label == "No rotación") %>%
  pull(n)

si_rot <- df_hextra %>%
  filter(rotacion_label == "Sí rotación") %>%
  pull(n)

# -----------------------------------------------------------------------------
# 1. BIVARIADO - BLOXPLOT
# -----------------------------------------------------------------------------

# =========================
# FUNCIÓN REUTILIZABLE
# =========================

# boxplot_highcharter <- function(data, variable, titulo, etiqueta_y) {
# 
#   var_name <- deparse(substitute(variable))
# 
#   data$rotacion_label <- ifelse(
#     data$rotacion == 0,
#     "0 = No rotación",
#     "1 = Sí rotación"
#   )
# 
#   box_stats <- data %>%
#     group_by(rotacion_label) %>%
#     summarise(
#       low = min(.data[[var_name]], na.rm = TRUE),
#       q1 = quantile(.data[[var_name]], 0.25, na.rm = TRUE),
#       median = median(.data[[var_name]], na.rm = TRUE),
#       q3 = quantile(.data[[var_name]], 0.75, na.rm = TRUE),
#       high = max(.data[[var_name]], na.rm = TRUE),
#       mean = mean(.data[[var_name]], na.rm = TRUE),
#       .groups = "drop"
#     )
# 
#   box_data <- lapply(1:nrow(box_stats), function(i) {
#     list(
#       as.numeric(box_stats$low[i]),
#       as.numeric(box_stats$q1[i]),
#       as.numeric(box_stats$median[i]),
#       as.numeric(box_stats$q3[i]),
#       as.numeric(box_stats$high[i])
#     )
#   })
# 
#   mean_data <- lapply(1:2, function(i) {
#     list(
#       x = i - 1,
#       y = as.numeric(box_stats$mean[i])
#     )
#   })
# 
#   highchart() %>%
#     hc_chart(type = "boxplot") %>%
#     hc_title(text = titulo) %>%
#     hc_xAxis(
#       categories = box_stats$rotacion_label,
#       title = list(text = "Rotación")
#     ) %>%
#     hc_yAxis(
#       title = list(text = etiqueta_y)
#     ) %>%
#     hc_add_series(
#       name = "Distribución",
#       data = box_data,
#       tooltip = list(
#         pointFormat = "<b>Media:</b> {point.y:.2f}"
#       ),
#       enableMouseTracking = FALSE
#     ) %>%
#     hc_add_series(
#       name = "Media",
#       type = "scatter",
#       data = mean_data,
#       color = "red",
#       marker = list(radius = 5, symbol = "circle"),
#       dataLabels = list(
#         enabled = TRUE,
#         formatter = JS(
#           "function() { return Highcharts.numberFormat(this.y, 2); }"
#         ),
#         style = list(
#           color = "red",
#           fontWeight = "bold",
#           textOutline = "none"
#         ),
#         y = -10
#       ),
#       tooltip = list(enabled = FALSE)
#     ) %>%
#     hc_add_series(
#       name = "Línea de medias",
#       type = "line",
#       data = mean_data,
#       color = "red",
#       marker = list(enabled = FALSE),
#       enableMouseTracking = FALSE,
#       showInLegend = FALSE
#     )
# }
# 
# 
# 
# boxplot_highcharter(
#   data = data,
#   variable = antiguedad_cargo,
#   titulo = "Antigüedad en el cargo según rotación",
#   etiqueta_y = "Años en el cargo"
# )
# 
# 


# -----------------------------------------------------------------------------
# 1. # VARIABLES NO CONSIDERADAS
# -----------------------------------------------------------------------------


# =========================
# GENERO
# =========================

# Crear tabla de frecuencias
#df_genero <- data.frame(
#  genero = c(0, 1),
#  frecuencia = c(
#    sum(data$genero == 0, na.rm = TRUE),
#    sum(data$genero == 1, na.rm = TRUE)
#  )
#) %>%
#  mutate(
#    etiqueta = c("Femenino", "Masculino")
#  )


# Gráfico
# highchart() %>%
#   hc_chart(type = "column") %>%
#   hc_title(text = "Distribución del género de los empleados") %>%
#   hc_xAxis(
#     categories = df_genero$etiqueta,
#     title = list(text = "Género")
#   ) %>%
#   hc_yAxis(
#     title = list(text = "Número de empleados")
#   ) %>%
#   hc_add_series(
#     name = "Frecuencia",
#     data = df_genero$frecuencia
#   ) %>%
#   hc_tooltip(
#     useHTML = TRUE,
#     pointFormat = paste0(
#       "<b>Género:</b> {point.category}<br>",
#       "<b>Empleados:</b> {point.y}"
#     )
#   ) %>%
#   hc_plotOptions(
#     column = list(
#       borderWidth = 1
#     )
#   )


# =========================
# EQUILIBRIO TRABAJO - VIDA
# =========================

# # Datos
# equilibrio <- data$equilibrio_trabajo_vida
# 
# # Tabla de frecuencias
# df_equilibrio <- data.frame(
#   nivel = sort(unique(equilibrio))
# ) %>%
#   mutate(
#     frecuencia = sapply(nivel, function(x) sum(equilibrio == x, na.rm = TRUE)),
#     etiqueta = paste("Nivel", nivel)
#   )
# 
# # Gráfico
# highchart() %>%
#   hc_chart(type = "column") %>%
#   hc_title(text = "Distribución del equilibrio trabajo-vida") %>%
#   hc_xAxis(
#     categories = df_equilibrio$etiqueta,
#     title = list(text = "Nivel de equilibrio")
#   ) %>%
#   hc_yAxis(
#     title = list(text = "Número de empleados")
#   ) %>%
#   hc_add_series(
#     name = "Frecuencia",
#     data = df_equilibrio$frecuencia,
#     color = "#f7a35c"
#   ) %>%
#   hc_tooltip(
#     useHTML = TRUE,
#     pointFormat = paste0(
#       "<b>Nivel:</b> {point.category}<br>",
#       "<b>Empleados:</b> {point.y}"
#     )
#   )
# 
# boxplot_highcharter(
#   data = data,
#   variable = equilibrio_trabajo_vida,
#   titulo = "Equilibrio del empleado entre Trabajo y vida personal",
#   etiqueta_y = "Nivel de satisfacción"
# )


# =========================
# EDAD
# =========================

# edad <- data$edad
# 
# # Crear cortes cada 5 años
# breaks_edad <- c(
#   18, 20, 
#   seq(
#     from = 25,
#     to = ceiling(max(edad, na.rm = TRUE) / 5) * 5,
#     by = 5
#   )
# )
# 
# # Histograma base
# hist_edad <- hist(edad, breaks = breaks_edad, plot = FALSE)
# 
# # Data frame
# df_edad <- data.frame(
#   xmin = hist_edad$breaks[-length(hist_edad$breaks)],
#   xmax = hist_edad$breaks[-1],
#   frecuencia = hist_edad$counts
# ) %>%
#   mutate(
#     rango = paste0(xmin, " - ", xmax, " años")
#   )
# 
# # Gráfico interactivo
# highchart() %>%
#   hc_chart(type = "column") %>%
#   
#   hc_title(text = "Distribución de la edad de los empleados") %>%
#   
#   hc_xAxis(
#     categories = df_edad$rango,
#     title = list(text = "Rango de edad")
#   ) %>%
#   
#   hc_yAxis(
#     title = list(text = "Número de empleados")
#   ) %>%
#   
#   hc_add_series(
#     name = "Frecuencia",
#     data = df_edad$frecuencia,
#     color = "#7cb5ec"
#   ) %>%
#   
#   hc_tooltip(
#     useHTML = TRUE,
#     pointFormat = paste0(
#       "<b>Rango:</b> {point.category}<br>",
#       "<b>Empleados:</b> {point.y}"
#     )
#   ) %>%
#   
#   hc_plotOptions(
#     column = list(
#       borderWidth = 1
#     )
#   )
# 
# boxplot_highcharter(
#   data = data,
#   variable = edad,
#   titulo = "Rango de edad empleados",
#   etiqueta_y = "Edad Empleado"
# )


# =========================
# SATISFACCION LABORAL
# =========================

#table(data$satisfaccion_laboral)

# df_sat <- data.frame(
#   nivel = sort(unique(data$satisfaccion_laboral))
# )
# 
# df_sat$frecuencia <- sapply(df_sat$nivel, function(x) {
#   sum(data$satisfaccion_laboral == x, na.rm = TRUE)
# })
# 
# df_sat$nivel_label <- paste("Nivel", df_sat$nivel)
# 
# table(data$satisfaccion_laboral)
# highchart() %>%
#   hc_chart(type = "column") %>%
#   hc_title(text = "Distribución de la satisfacción laboral") %>%
#   hc_xAxis(categories = df_sat$nivel_label,
#            title = list(text = "Nivel de satisfacción")) %>%
#   hc_yAxis(title = list(text = "Número de empleados")) %>%
#   hc_add_series(
#     name = "Frecuencia",
#     data = df_sat$frecuencia
#   )
# 
# boxplot_highcharter(
#   data = data,
#   variable = satisfaccion_laboral,
#   titulo = "Satisfacción laboral según rotación",
#   etiqueta_y = "Nivel de satisfacción"
# )
# 
# prop.table(table(data$satisfaccion_laboral, data$rotacion), 1)
