﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УзелОтбора = Неопределено;
	Если Параметры.Свойство("Ссылка", УзелОтбора) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Ссылка", УзелОтбора);
	КонецЕсли;
	
	Заголовок = Нстр("ru = 'Выберите устройство с индивидуальными настройками для синхронизации'");
КонецПроцедуры

#КонецОбласти
