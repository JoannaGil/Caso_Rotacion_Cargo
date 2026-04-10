


# -----------------------------------------------------------------------------
# 0. LIBRERÍAS REQUERIDAS
# -----------------------------------------------------------------------------
# Asegúrate de tener instaladas las siguientes librerías antes de ejecutar.
# Descomenta las líneas de install.packages() solo la primera vez.

# install.packages("devtools")
# devtools::install_github("centromagis/paqueteMODELOS", force = TRUE)
# install.packages(c("janitor", "dplyr", "skimr"))

library(paqueteMODELOS)  # Fuente del dataset
library(janitor)         # Limpieza de nombres de columnas (clean_names)
library(dplyr)           # Manipulación de datos (rename, pipes %>%)
library(skimr)           # Resumen estadístico enriquecido (skim)

# -----------------------------------------------------------------------------
# 1. CARGA DE DATOS
# -----------------------------------------------------------------------------
# El dataset `rotacion` contiene información de 1.470 empleados y 26 variables.
# Fue construido para predecir si un empleado cambiara de cargo (rotación).
#
# DICCIONARIO DE VARIABLES:
# ─────────────────────────────────────────────────────────────────────────────
#  VARIABLE                     TIPO      DESCRIPCIÓN
# ─────────────────────────────────────────────────────────────────────────────
#  rotacion                     num       TARGET: 1 = Si Rotacion, 0 = No Rotacion
#  edad                         num       Edad del empleado (años)
#  viaje_de_negocios            Factor    Frecuencia de viajes laborales
#                                         (No_Viaja / Raramente / Frecuentemente)
#  departamento                 Factor    Área de trabajo (Ventas / IyD / RH)
#  distancia_casa               num       Distancia al trabajo (km)
#  educacion                    num       Nivel educativo (escala 1–5)
#  campo_educacion              Factor    Área de formación académica (6 niveles)
#  satisfaccion_ambiental       Factor    Satisfacción con el entorno físico (1–4)
#  genero                       Factor    Género del empleado (F / M)
#  cargo                        Factor    Puesto de trabajo (9 categorías)
#  satisfaccion_laboral         Factor    Satisfacción con el trabajo (1–4)
#  estado_civil                 Factor    Estado civil (Soltero / Casado / Divorciado)
#  ingreso_mensual              num       Salario mensual en unidades monetarias
#  trabajos_anteriores          num       Número de empresas previas donde trabajó
#  horas_extra                  Factor    Realiza horas extra (Sí / No)
#  porcentaje_aumento_salarial  num       Incremento salarial reciente (%)
#  rendimiento_laboral          Factor    Evaluación de desempeño (1–4)
#  anos_experiencia             num       Años de experiencia laboral total
#  capacitaciones               num       Número de capacitaciones en el último año
#  equilibrio_trabajo_vida      num       Balance vida-trabajo percibido (escala 1–4)
#  antiguedad                   num       Años trabajados en la empresa actual
#  antiguedad_cargo             num       Años en el cargo actual
#  anos_ultima_promocion        num       Años desde el último ascenso
#  anos_acargo_con_mismo_jefe   num       Años trabajando con el jefe actual
#  log_ingresos                 num       Transformación log del ingreso mensual
#                                         (reduce el sesgo por outliers salariales)
#  cargo_grupo                  Factor    Agrupación del cargo en 4 categorías
#                                         (Otros / RH / Tec.lab / [4to nivel])

# -----------------------------------------------------------------------------
# El dataset `rotacion` proviene del paquete paqueteMODELOS.

#install.packages("devtools") # solo la primera vez
#devtools::install_github("centromagis/paqueteMODELOS", force =TRUE)

data("rotacion")

data = rotacion[,c("Rotación",
                   "Edad", "Antigüedad", "Ingreso_Mensual",
                   "Genero", "Satisfación_Laboral","Rendimiento_Laboral")]


# -----------------------------------------------------------------------------
# 2. INSPECCIÓN INICIAL DEL DATASET COMPLETO
# -----------------------------------------------------------------------------
# Antes de trabajar solo con las variables seleccionadas, exploramos
# el dataset original para entender su estructura completa.

# Vista rápida de las primeras 6 filas
head(rotacion)

# Número de filas y columnas
dim(rotacion)
# Salida esperada: [1] n_filas  n_columnas

# Listado de nombres de variables disponibles
names(rotacion)

# -----------------------------------------------------------------------------
# 3. LIMPIEZA DE NOMBRES DE VARIABLES
# -----------------------------------------------------------------------------
# clean_names() del paquete janitor estandariza los nombres a snake_case,
# eliminando tildes, espacios y caracteres especiales.

rotacion_limpio <- clean_names(rotacion)

# Corrección manual de un error ortográfico en el nombre de la variable:
# "satisfacion_laboral" → "satisfaccion_laboral" (faltaba una 'c')
rotacion_limpio <- rotacion_limpio %>%
  rename(satisfaccion_laboral = satisfacion_laboral)

# Verificar que los nombres quedaron correctamente actualizados
names(rotacion_limpio)


# -----------------------------------------------------------------------------
# 4. INSPECCIÓN ESTRUCTURAL Y ESTADÍSTICA
# -----------------------------------------------------------------------------

# Tipos de dato de cada variable (numérico, factor, character, etc.)
str(rotacion_limpio)

# Resumen estadístico básico: mínimo, media, mediana, máximo por variable
summary(rotacion_limpio)

# Resumen avanzado con skimr: incluye histogramas en consola, conteo de NAs,
# percentiles y estadísticas completas. Muy útil para un diagnóstico rápido.
skim(rotacion_limpio)

# -----------------------------------------------------------------------------
# 5. VALORES FALTANTES (NA)
# -----------------------------------------------------------------------------
# El skim() anterior ya indicó si hay NAs, pero aquí lo verificamos
# de forma explícita variable por variable.

colSums(is.na(rotacion_limpio))
# Resultado esperado: todas las variables deberían reportar 0 NAs.
# Si alguna variable tiene NAs, se debe decidir entre:
#   - Imputar (media, mediana, moda, modelo)
#   - Eliminar registros incompletos

# -----------------------------------------------------------------------------
# 6. REGISTROS DUPLICADOS
# -----------------------------------------------------------------------------
# Un duplicado exacto puede sesgar el modelo, ya que el mismo empleado
# contaría más de una vez en el entrenamiento.

# Conteo de filas duplicadas
sum(duplicated(rotacion_limpio))
# Resultado esperado: 0 duplicados.

# Si existieran duplicados, se eliminarían con:
# rotacion_limpio <- rotacion_limpio %>% distinct()
# (No fue necesario en este caso)

# -----------------------------------------------------------------------------
# 7. REVISIÓN FINAL DE TIPOS DE DATO
# -----------------------------------------------------------------------------
# Confirmamos una vez más los tipos de dato tras la limpieza.
# Es importante que:
#   - Variables categóricas sean factor (no character)
#   - Variables numéricas sean numeric o integer

str(rotacion_limpio)

# -----------------------------------------------------------------------------
# 7. VERIFICACION, MODIFICACION Y CREACION DE VARIABLES
# -----------------------------------------------------------------------------

data <- rotacion_limpio %>%
  mutate(
    # Objetivo
    rotacion = if_else(rotacion == "Si", 1, 0),
    
    # Factores nominales
    genero            = factor(genero,            levels = c("F", "M")),
    horas_extra       = factor(horas_extra,        levels = c("No", "Si")),
    estado_civil      = factor(estado_civil,       levels = c("Soltero", "Casado", "Divorciado")),
    departamento      = factor(departamento,       levels = c("Ventas", "IyD", "RH")),
    viaje_de_negocios = factor(viaje_de_negocios, levels = c("No_Viaja", "Raramente", "Frecuentemente")),
    campo_educacion   = factor(campo_educacion,   levels = c("Ciencias", "Otra", "Salud", "Mercadeo", "Tecnicos", "Humanidades")),
    cargo             = factor(cargo),
    
    # Numéricas
    log_ingresos  = log(ingreso_mensual),
    distancia_casa = as.numeric(distancia_casa),
    satisfaccion_laboral_num = as.numeric(as.character(satisfaccion_laboral)),
    
    # Factores ordinales
    satisfaccion_ambiental = factor(satisfaccion_ambiental, levels = 1:4),
    satisfaccion_laboral   = factor(satisfaccion_laboral,   levels = 1:4),
    rendimiento_laboral    = factor(rendimiento_laboral,    levels = 1:4)
  ) %>%
  # Agrupación de cargo para reducir ruido
  mutate(
    cargo_grupo = case_when(
      cargo %in% c("Representante_Ventas", "Ejecutivo_Ventas") ~ "Ventas",
      cargo %in% c("Recursos_Humanos")                         ~ "RH",
      cargo %in% c("Tecnico_Laboratorio")                      ~ "Tec.lab",
      TRUE                                                      ~ "Otros"
    ),
    cargo_grupo = factor(cargo_grupo)
  )

str(data)

# -----------------------------------------------------------------------------
# 1. ANALISIS EXPLORATORIO INICIAL 
# -----------------------------------------------------------------------------

