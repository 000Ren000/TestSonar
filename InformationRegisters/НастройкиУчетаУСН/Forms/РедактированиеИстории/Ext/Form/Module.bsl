﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Организация = Параметры.Организация;
	ТолькоПросмотр = Параметры.ТолькоПросмотр;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"Организация",
		Организация,
		ВидСравненияКомпоновкиДанных.Равно, , 
		ЗначениеЗаполнено(Организация),,);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Добавить(Команда)
	ОповеститьОВыборе(Новый Структура("Организация, Период", 
		Организация,
		ОбщегоНазначенияКлиент.ДатаСеанса()));
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОповеститьОВыборе(ВыбраннаяСтрока);
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	ОповеститьОВыборе(Элементы.Список.ТекущаяСтрока);
КонецПроцедуры

#КонецОбласти