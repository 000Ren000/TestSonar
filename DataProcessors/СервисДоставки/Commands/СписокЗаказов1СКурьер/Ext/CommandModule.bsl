﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОчиститьСообщения();
	Параметры = Новый Структура();
	Параметры.Вставить("ТипГрузоперевозки", 2);
	СервисДоставкиКлиент.ОткрытьФормуСпискаЗаказовНаДоставку(Параметры);
		
КонецПроцедуры

#КонецОбласти

