#вывод таблицы "eddypro"
library(readr)
dt <- read_csv("C:/Users/HP/Downloads/eddypro.csv", 
               skip = 1, na =c("","NA","-9999","-9999.0"), comment=c("["))
View(dt)
#выводим имена dt
names(dt)
#исключаем лишние переменные
dt<-dt[,c(-6:-7,-9:-10,-12:-13,-15:-16,-18:-19,-21:-22,-70,-78:-131)]
dt<-dt[-1,]
#избавляемся от столбца roll, содержащего только NA
dt = select(dt, -(roll))
#выбираем данные только за летний период
dt<-dt[dt$DOY>152&dt$DOY<244,c(1:ncol(dt))]
#выбираем только дневные часы
dt<-dt[dt$daytime<=FALSE,]
#вывод каждой отдельной переменной
glimpse(dt)
#преобразуем значения char в фактор
dt = dt %>% mutate_if(is.character, factor)
#численные значения = TRUE, остальные = FALSE
sapply(dt,is.numeric)
#выводим переменные, имеющие только численные значения
dt_numeric = dt[,sapply(dt,is.numeric)]
dt_numeric
#выводим переменные, имеющие не численные значения
dt_non_numeric = dt[,!sapply(dt,is.numeric)]
dt_non_numeric
#проведем корелляционный анализ, избавляясь от всех строк, где есть хоть одно значение NA
cor_dt = cor(na.omit(dt_numeric))
cor_dt
#преобразование полученной матрицы в таблицу
cor_dt = cor(na.omit(dt_numeric)) %>% as.data.frame %>% select(co2_flux)
cor_dt
#удаление из таблицы значений NA
cor_dt <- na.omit(cor_dt)
#из столбца выбираем значения, R^2 которых больше 0,1
vars = row.names(cor_dt)[cor_dt$co2_flux^2 > .1] %>% na.exclude
vars
#сбор всех переменных из вектора с именнами переменных в одну формулу
formula=as.formula(paste("co2_flux~",paste(vars,collapse="+"),sep=""))
formula
#построение модели № 1
mod1 = lm(co2_flux ~ H + co2_flux + co2_molar_density + co2_mole_fraction + co2_mixing_ratio, data=dt)
summary(mod1)
#построение графиков модели №1
plot(mod1)
#построение модели № 2
mod2 = lm(co2_flux ~ H + co2_flux + co2_mole_fraction + co2_mixing_ratio, data=dt)
summary(mod2)
#построение графиков модели № 2
plot(mod2)
