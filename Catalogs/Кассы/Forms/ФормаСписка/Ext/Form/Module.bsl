﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьОтборыСписка();
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Кассы);
	Элементы.СписокИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Элементы.ОрганизацияОтбор.ТолькоПросмотр Тогда
		Настройки.Удалить("ОрганизацияОтбор");
	Иначе
		ОрганизацияОтбор = Настройки.Получить("ОрганизацияОтбор");
	КонецЕсли;
	
	УстановитьОтборДинамическогоСписка();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОрганизацияОтборПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияОтборПриИзмененииСервер()
	
	УстановитьОтборДинамическогоСписка();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборДинамическогоСписка()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Владелец", ОрганизацияОтбор, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОрганизацияОтбор));
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыСписка()
	
	Если Параметры.Свойство("Отбор") Тогда
		Если Параметры.Отбор.Свойство("Организация") Тогда
			ОрганизацияОтбор = Параметры.Отбор.Организация;
			Элементы.ОрганизацияОтбор.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьОтборДинамическогоСписка();
	
КонецПроцедуры

#КонецОбласти