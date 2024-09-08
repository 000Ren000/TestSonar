﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(
		Объект, Параметры.Объект, "СоздаватьКонтрагентов, ПроводитьДокументы, РежимЗаполненияКонтрагентаПоQRПлатежу");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)

	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("СоздаватьКонтрагентов", Объект.СоздаватьКонтрагентов);
	ПараметрыЗакрытия.Вставить("ПроводитьДокументы", Объект.ПроводитьДокументы);
	ПараметрыЗакрытия.Вставить("РежимЗаполненияКонтрагентаПоQRПлатежу", Объект.РежимЗаполненияКонтрагентаПоQRПлатежу);
	
	Закрыть(ПараметрыЗакрытия);

КонецПроцедуры

#КонецОбласти
