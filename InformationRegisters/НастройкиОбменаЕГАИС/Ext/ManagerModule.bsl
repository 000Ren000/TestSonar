﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияЕГАИС.ЭтоРасширеннаяВерсияГосИС() Тогда
		МодульИнтеграцияЕГАИСВызовСервера = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияЕГАИСВызовСервера");
		МодульИнтеграцияЕГАИСВызовСервера.ПриПолученииФормыРегистраСведений(
			"НастройкиОбменаЕГАИС",
			ВидФормы,
			Параметры,
			ВыбраннаяФорма,
			ДополнительнаяИнформация,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

// Регистрирует записи регистра с незаполненным таймаутом.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиОбменаЕГАИС.ИдентификаторФСРАР КАК ИдентификаторФСРАР,
	|	НастройкиОбменаЕГАИС.РабочееМесто КАК РабочееМесто
	|ИЗ
	|	РегистрСведений.НастройкиОбменаЕГАИС КАК НастройкиОбменаЕГАИС
	|ГДЕ
	|	НастройкиОбменаЕГАИС.Таймаут = 0";
	
	Данные = Запрос.Выполнить().Выгрузить();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Данные, ДополнительныеПараметры);
	
КонецПроцедуры

// Заполняет таймаут в зарегистрированных к обработке записях регистра.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
	ДополнительныеПараметры.ВыбиратьПорциями = Ложь;
	
	ДанныеКОбработке = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(Параметры.Очередь, ПолноеИмяРегистра(), ДополнительныеПараметры);
	
	Пока ДанныеКОбработке.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра());
			ЭлементБлокировки.УстановитьЗначение("ИдентификаторФСРАР", ДанныеКОбработке.ИдентификаторФСРАР);
			ЭлементБлокировки.УстановитьЗначение("РабочееМесто",       ДанныеКОбработке.РабочееМесто);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ИдентификаторФСРАР", ДанныеКОбработке.ИдентификаторФСРАР);
			Запрос.УстановитьПараметр("РабочееМесто", ДанныеКОбработке.РабочееМесто);
			
			Запрос.Текст =
			"ВЫБРАТЬ
			|	НастройкиОбменаЕГАИС.ИдентификаторФСРАР КАК ИдентификаторФСРАР,
			|	НастройкиОбменаЕГАИС.РабочееМесто КАК РабочееМесто,
			|	НастройкиОбменаЕГАИС.АдресУТМ КАК АдресУТМ,
			|	НастройкиОбменаЕГАИС.ПортУТМ КАК ПортУТМ,
			|	ВЫБОР
			|		КОГДА НастройкиОбменаЕГАИС.Таймаут = 0
			|			ТОГДА 60
			|		ИНАЧЕ НастройкиОбменаЕГАИС.Таймаут
			|	КОНЕЦ КАК Таймаут,
			|	НастройкиОбменаЕГАИС.ОбменНаСервере КАК ОбменНаСервере,
			|	НастройкиОбменаЕГАИС.ОбменНаКлиентеРасписание КАК ОбменНаКлиентеРасписание,
			|	НастройкиОбменаЕГАИС.ОбменНаКлиентеПоРасписанию КАК ОбменНаКлиентеПоРасписанию,
			|	НастройкиОбменаЕГАИС.ЗагружатьВходящиеДокументы КАК ЗагружатьВходящиеДокументы
			|ИЗ
			|	РегистрСведений.НастройкиОбменаЕГАИС КАК НастройкиОбменаЕГАИС
			|ГДЕ
			|	НастройкиОбменаЕГАИС.ИдентификаторФСРАР = &ИдентификаторФСРАР
			|	И НастройкиОбменаЕГАИС.РабочееМесто = &РабочееМесто";
			
			НаборЗаписей = СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ИдентификаторФСРАР.Установить(ДанныеКОбработке.ИдентификаторФСРАР);
			НаборЗаписей.Отбор.РабочееМесто.Установить(ДанныеКОбработке.РабочееМесто);
			
			//@skip-check query-in-loop
			НаборЗаписей.Загрузить(Запрос.Выполнить().Выгрузить());
		
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось записать данные в регистр %ИмяРегистра% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяРегистра%", ПолноеИмяРегистра());
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
									УровеньЖурналаРегистрации.Ошибка,
									Метаданные.РегистрыСведений.НастройкиОбменаЕГАИС,
									Неопределено,
									ТекстСообщения);
			
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра());
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолноеИмяРегистра()
	
	Возврат "РегистрСведений.НастройкиОбменаЕГАИС";
	
КонецФункции

#КонецОбласти

#КонецЕсли