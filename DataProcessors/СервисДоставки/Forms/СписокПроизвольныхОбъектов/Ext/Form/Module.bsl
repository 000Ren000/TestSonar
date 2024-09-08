﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.ЗагрузитьЗначения(Параметры.МассивОбъектов);
	
	Если Параметры.Свойство("ЗаголовокФормы") Тогда 
		Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Список[ВыбраннаяСтрока].Значение);
	
КонецПроцедуры

#КонецОбласти
