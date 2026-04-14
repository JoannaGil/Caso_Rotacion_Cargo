

library(dplyr)
library(pROC)

# 1. Crear dataset de trabajo (MUY importante)
df_modelo <- data

# 2. Crear variable log (ANTES del modelo)
df_modelo <- df_modelo %>%
  mutate(log_ingresos = log(ingreso_mensual))

# 3. Ajustar modelo completo (opcional)
modelo_nuevo <- glm(
  rotacion ~ horas_extra + cargo_grupo + viaje_de_negocios + 
    satisfaccion_laboral_num + log_ingresos + antiguedad_cargo,
  data = df_modelo,
  family = binomial
)

modelo_nuevo

# 4. Dividir datos (train/test)
set.seed(123)
train_index <- sample(1:nrow(df_modelo), 0.7 * nrow(df_modelo))

train <- df_modelo[train_index, ]
test  <- df_modelo[-train_index, ]

# 5. Ajustar modelo en train
modelo_train <- glm(
  rotacion ~ horas_extra + cargo_grupo + viaje_de_negocios + 
    satisfaccion_laboral_num + log_ingresos + antiguedad_cargo,
  data = train,
  family = binomial
)

# 6. Predicciones
pred_train <- predict(modelo_train, newdata = train, type = "response")
pred_test  <- predict(modelo_train, newdata = test, type = "response")

# 7. Validación de tamaños (debug)
length(train$rotacion)
length(pred_train)

length(test$rotacion)
length(pred_test)

# 8. AUC
auc_train <- roc(response = train$rotacion, predictor = pred_train)$auc
auc_test  <- roc(response = test$rotacion, predictor = pred_test)$auc

auc_train
auc_test



AIC(modelo_nuevo)
#
null_dev <- modelo_nuevo$null.deviance
res_dev <- modelo_nuevo$deviance
#
pseudo_r2 <- 1 - (res_dev / null_dev)
pseudo_r2
#
# # Probabilidades predichas
prob_pred <- predict(modelo_nuevo, type = "response")
#
# # Curva ROC
roc_modelo <- roc(
  response = df_modelo[["rotacion"]],
  predictor = prob_pred
)

# # AUC
auc(roc_modelo)


# # Clasificación con umbral 0.5
pred_clase <- ifelse(prob_pred >= 0.5, 1, 0)

# # Matriz de confusión
table(Predicho = pred_clase, Real = df_modelo$rotacion)


# Coeficientes
coeficientes <- coef(modelo_nuevo)

# Odds ratio
odds_ratio <- exp(coeficientes)

# Intervalos de confianza
ic <- exp(confint(modelo_nuevo))

# Tabla final
tabla_resultados <- data.frame(
  Variable = names(coeficientes),
  Coeficiente = round(coeficientes, 3),
  Odds_Ratio = round(odds_ratio, 3),
  IC_Inf = round(ic[,1], 3),
  IC_Sup = round(ic[,2], 3)
)

tabla_resultados

