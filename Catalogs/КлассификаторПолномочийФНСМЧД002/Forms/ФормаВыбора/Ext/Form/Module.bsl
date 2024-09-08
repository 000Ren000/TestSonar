﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.КодКлассификатора) Тогда
		
		Элементы.Список.ТекущаяСтрока = Справочники.КлассификаторПолномочийФНСМЧД002.НайтиПолномочиеПоКоду(
			Параметры.КодКлассификатора);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Структура = Новый Структура;
		Структура.Вставить("КодКлассификатора", ТекущиеДанные.КодКлассификатора);
		Структура.Вставить("Полномочие",        ТекущиеДанные.Полномочие);
		
		Закрыть(Структура);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти