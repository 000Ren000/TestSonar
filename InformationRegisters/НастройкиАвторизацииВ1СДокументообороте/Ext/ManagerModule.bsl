﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВызватьИсключение НСтр("ru = 'Настройки авторизации в 1С:Документообороте не предназначены для просмотра или редактирования.'");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли