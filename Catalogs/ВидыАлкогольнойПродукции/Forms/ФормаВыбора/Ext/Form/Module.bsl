﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ФормаПодобратьИзКлассификатора.Видимость = ПравоДоступа("ИнтерактивноеДобавление", Метаданные.Справочники.ВидыАлкогольнойПродукции);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияСобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьИзКлассификатора(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПодборИзКлассификатораВидовПродукцииЕГАИС",, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	Если ОбщегоНазначенияЕГАИСКлиент.ЭтоРасширеннаяВерсияГосИС() Тогда
		МодульСобытияФормИСКлиентПереопределяемый = ОбщегоНазначенияКлиент.ОбщийМодуль("СобытияФормИСКлиентПереопределяемый");
		МодульСобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти