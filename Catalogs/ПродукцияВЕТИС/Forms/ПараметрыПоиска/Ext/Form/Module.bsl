﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	Если Не ПустаяСтрока(Идентификатор)
		И Не СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(Идентификатор) Тогда
		
		ТекстОшибки = НСтр("ru = 'Неправильно указан идентификатор'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, ,"Идентификатор",, Отказ);
		
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ИдентификаторПродукции", Идентификатор);
	
	ОткрытьФорму(
		"Справочник.ПродукцияВЕТИС.Форма.ФормаЭлемента",
		ПараметрыОткрытия, ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти