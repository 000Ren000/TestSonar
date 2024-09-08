﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма отчета.
//	КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//	Настройки - См. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере.
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаКоэффициентУпаковки",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки("ЦеныНоменклатуры.Упаковка",
																										"ЦеныНоменклатуры.Номенклатура"));

	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос = ТекстЗапроса;
	
	КомпоновщикМакета	= Новый КомпоновщикМакетаКомпоновкиДанных;
	НастройкиОтчета		= КомпоновщикНастроек.ПолучитьНастройки();
	МакетКомпоновки		= КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(ЗаголовкиПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных,
																КомпоновщикНастроек,
																ДокументРезультат,
																ВспомогательныеПараметрыОтчета());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЕдиницыИзмеренияДляОтчетов") Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(КомпоновщикНастроекФормы, "ЕдиницыКоличества");
	КонецЕсли;
	
КонецПроцедуры

Функция ЗаголовкиПолей()
	
	Возврат КомпоновкаДанныхСервер.ЗаголовкиПолейЕдиницИзмерений(КомпоновщикНастроек);
	
КонецФункции

Функция ВспомогательныеПараметрыОтчета()
	
	ВспомогательныеПараметры = Новый Массив;
	ВспомогательныеПараметры.Добавить("КоличественныеИтогиПоЕдИзм");
	
	КомпоновкаДанныхСервер.ДобавитьВспомогательныеПараметрыОтчетаПоФункциональнымОпциям(ВспомогательныеПараметры);
	
	Возврат ВспомогательныеПараметры;

КонецФункции

#КонецОбласти

#КонецЕсли