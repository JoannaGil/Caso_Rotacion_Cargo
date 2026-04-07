


# -----------------------------------------------------------------------------
# 0. LIBRERÍAS REQUERIDAS
# -----------------------------------------------------------------------------
library(paqueteMODELOS)
library(ggplot2)
library(summarytools)
library(janitor)
library(skimr)
library(dplyr)


# -----------------------------------------------------------------------------
# 1. CARGA DE DATOS 
# -----------------------------------------------------------------------------

#install.packages("devtools") # solo la primera vez
#devtools::install_github("centromagis/paqueteMODELOS", force =TRUE)
data("rotacion")

data = rotacion[,c("Rotación",
                   "Edad", "Antigüedad", "Ingreso_Mensual",
                   "Genero", "Satisfación_Laboral","Rendimiento_Laboral")]


# =========================
# 3. INSPECCIÓN INICIAL
# =========================

# Ver primeras filas
head(rotacion)
# Dimensiones del dataset
dim(rotacion)
# Nombres de variables
names(rotacion)

# Normalizanos formato nombre varaibles

rotacion_limpio <- clean_names(rotacion)
names(rotacion_limpio)

# Estructura de los datos
str(rotacion_limpio)

# Resumen estadístico general
summary(rotacion_limpio)

# Resumen más detallado
skim(rotacion_limpio)

## No contamos con datos faltantes segun lo visto en la "skim" pero rectificaremos 

# =========================
# 4. VALORES FALTANTES
# =========================
# Cantidad de NA por variable
colSums(is.na(rotacion_limpio))

# =========================
# 5. REGISTROS DUPLICADOS
# =========================
# Número de filas duplicadas
sum(duplicated(rotacion_limpio))

# Eliminar duplicados si existen
#datos_limpios <- datos_limpios %>% distinct() # No fue el caso


# =========================
# 6. TIPOS DE DATOS
# =========================
str(rotacion_limpio)

#### Conversión de variables al tipo adecuado

# =========================
# CREACIÓN DE VARIABLES
# =========================

#unique(rotacion_limpio$rotacion)
#unique(rotacion_limpio$genero)

data <- rotacion_limpio %>%
  mutate(
    rotacion = as.numeric(rotacion == "si"),
    genero = as.numeric(genero == "m"),
    ingresos = ingreso_mensual,
    
    satlab2 = as.numeric(satisfaccion_laboral == 2),
    satlab3 = as.numeric(satisfaccion_laboral == 3),
    satlab4 = as.numeric(satisfaccion_laboral == 4),
    
    redlab = as.numeric(rendimiento_laboral == 4)
  )


# -----------------------------------------------------------------------------
# 1. ANALISIS EXPLORATORIO DE DATOS 
# -----------------------------------------------------------------------------

head(rotacion)
summary(rotacion)
