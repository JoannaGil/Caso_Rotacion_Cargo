


# -----------------------------------------------------------------------------
# 0. LIBRERÍAS REQUERIDAS
# -----------------------------------------------------------------------------
library(paqueteMODELOS)
library(ggplot2)
library(summarytools)
library(janitor)
library(skimr)
library(dplyr)
library(highcharter)
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

# Corregir una varibale manualmente - Ortografia
rotacion_limpio <- rotacion_limpio %>%
  rename(satisfaccion_laboral = satisfacion_laboral)
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

#unique(data$rotacion)
#unique(data$genero)
#unique(data$estado_civil)
#unique(data$departamento)
#unique(data$satisfaccion_laboral)
#unique(data$rendimiento_laboral)
#unique(data$viaje_de_negocios)
unique(data$cargo)


data <- rotacion_limpio %>%
  mutate(
    # Variable objetivo binaria
    rotacion = if_else(rotacion == "Si", 1, 0),
    
    # Categóricas nominales
    genero = factor(genero, levels = c("F", "M")),
    horas_extra = factor(horas_extra, levels = c("No", "Si")),
    estado_civil = factor(estado_civil, levels = c("Soltero", "Casado", "Divorciado")),
    departamento = factor(departamento, levels = c("Ventas", "IyD", "RH")),
    viaje_de_negocios = factor(viaje_de_negocios,levels = c("No_Viaja", "Raramente", "Frecuentemente")),
    campo_educacion = factor(campo_educacion, levels = c("Ciencias", "Otra", "Salud", "Mercadeo", "Tecnicos", "Humanidades")),
    cargo = factor(cargo),
    
    # Numéricas
    log_ingresos = log(ingreso_mensual),
    distancia_casa = as.numeric(distancia_casa),
    
    # Ordinales: tratarlas como factor en logística suele ser más seguro
    satisfaccion_ambiental = factor(satisfaccion_ambiental, levels = c(1, 2, 3, 4)),
    satisfaccion_laboral = factor(satisfaccion_laboral, levels = c(1, 2, 3, 4)),
    rendimiento_laboral = factor(rendimiento_laboral, levels = c(1, 2, 3, 4))
  )

# Ajustamos la variable cargo para disminuir el ruido
data <- data %>%
  mutate(
    cargo_grupo = case_when(
      cargo %in% c("Representante_Ventas", "Ejecutivo_Ventas") ~ "Ventas",
      cargo %in% c("Recursos_Humanos") ~ "RH",
      cargo %in% c("Tecnico_Laboratorio") ~ "Tec.lab",
      TRUE ~ "Otros"
    ),
    cargo_grupo = factor(cargo_grupo)
  )

str(data)


# -----------------------------------------------------------------------------
# 1. ANALISIS EXPLORATORIO INICIAL 
# -----------------------------------------------------------------------------

