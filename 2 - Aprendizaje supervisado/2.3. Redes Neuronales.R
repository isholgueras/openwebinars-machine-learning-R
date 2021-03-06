# El dataset Trigo.RData contiene datos pertenecientes a tres variedades de trigo. Se
# midieron siete parametros geometricos de los granos de trigo:
# 1. area A,
# 2. perimetro P,
# 3. compacidad C = 4 * pi * A/P^2,
# 4. longitud del nucleo,
# 5. ancho del nucleo,
# 6. coeciente de asimetra
# 7. longitud de la ranura del nucleo.
# La ultima columna contiene la etiqueta de cada una de las tres variedades (1,2,3)


set.seed(1)
load("Trigo.RData")

# Transformación de la variable objetivo a 3 columnas de tipo binario con valores 1 y -1
Datos = Trigo
Datos$Tipo1=-1
Datos$Tipo2=-1
Datos$Tipo3=-1

Datos$Tipo1 = ifelse(Datos$X8==1,1,Datos$Tipo1)
Datos$Tipo2 = ifelse(Datos$X8==2,1,Datos$Tipo2)
Datos$Tipo3 = ifelse(Datos$X8==3,1,Datos$Tipo3)

# Elimino la columna original
Datos$X8=NULL

# Normalización
for(k in 1:6){
    Datos[,k]=(Datos[,k]-mean(Datos[,k]))/(max(Datos[,k])-min(Datos[,k]))    
}
acierto=vector()

# División entrenamiento y test
index = sample(1:nrow(Datos),size=0.80*nrow(Datos))
train=Datos[index,]
test=Datos[-index,]

# Red neuronal
library(neuralnet)
nn <- neuralnet((Tipo1+Tipo2+Tipo3)~X1+X2+X3+X4+X5+X6+X7,
                data = train,
                hidden = 5,
                act.fct = "tanh",
                linear.output = FALSE,
                lifesign = "minimal")
# Plot de la red neuronal
plot(nn)
# Predicción del conjunto de test (la salida son 3 columnas)
pr.nn <- compute(nn, test[, 1:7])
# Escojo el máximo de cada columna de predicción
pred = max.col(pr.nn$net.result)
real = Trigo$X8[-index]
# Tasa de acierto
print("Tasa de acierto:")
print(mean(pred==real)*100)
# Matriz de confusión
table(pred,real)



