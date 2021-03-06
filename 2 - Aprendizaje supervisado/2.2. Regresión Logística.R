# Regresi�n log�stica
# Dataset que contiene admitidos y no admitidos a una universidad en funci�n de la nota de ciertos ex�menes
df <- read.csv("https://stats.idre.ucla.edu/stat/data/binary.csv")
head(df)
table(df$admit)

# Modelo de regresi�n log�stica
modelo <- glm(admit ~ gre+gpa+rank,data=df,family="binomial")
summary(modelo)

# Predicci�n
x <- data.frame(gre=790,gpa=3.8,rank=1)
p<- predict(modelo,x, type="response")
p

# Evaluar modelo
prediccion_prob<- predict(modelo,df,type="response")
summary(prediccion_prob)

df$prediccion_prob <-  prediccion_prob

install.packages("InformationValue")
library(InformationValue)

# Corte �ptimo en las probabilidades
opt <- optimalCutoff(df$admit, prediccion_prob)
opt

df$predicted <- ifelse(df$prediccion_prob>=opt,1,0)

# Matriz de confusi�n
table(df$predicted,df$admit)
confusionMatrix(df$admit, prediccion_prob, threshold = opt)

# Accuracy
1-misClassError(df$admit, prediccion_prob, threshold = opt) # Cambiar opt a 0.5

# Precision
Precision <- precision(df$admit, prediccion_prob, threshold = opt)
Precision

# Recall
Recall <- sensitivity(df$admit, prediccion_prob, threshold = opt)
Recall

# Specificity
specificity(df$admit, prediccion_prob, threshold = opt)

# F1 Score
(2*Precision*Recall)/(Precision+Recall)

# ROC
plotROC(actuals=df$admit, predictedScores=df$prediccion_prob)



