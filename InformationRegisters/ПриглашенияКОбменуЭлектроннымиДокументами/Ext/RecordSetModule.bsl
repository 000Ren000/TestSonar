﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	Если ЭтотОбъект.Количество() Тогда
		ПроверитьУникальностьПриглашений(Отказ);
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ЭтотОбъект.Количество() Тогда
		ОчиститьДублиВСуществующихЗаписях();
	КонецЕсли;

	КонтрагентыИзПриглашений = Новый Массив;

	Для Каждого Запись Из ЭтотОбъект Цикл
		Если ЗначениеЗаполнено(Запись.Контрагент) И КонтрагентыИзПриглашений.Найти(Запись.Контрагент) = Неопределено Тогда

			КонтрагентыИзПриглашений.Добавить(Запись.Контрагент);
		КонецЕсли;
	КонецЦикла;

	Если КонтрагентыИзПриглашений.Количество() Тогда
		РаботаСАбонентамиЭДО.ОбновитьСостоянияКонтрагентов(КонтрагентыИзПриглашений);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьУникальностьПриглашений(Отказ)

	ПроверяемыеПриглашения = ЭтотОбъект.Выгрузить( , "Ключ,ИдентификаторОрганизации,ИдентификаторКонтрагента");
	
	// Проверим новые записи
	СвернутыеПриглашения = ПроверяемыеПриглашения.Скопировать();
	КоличествоДо = СвернутыеПриглашения.Количество();
	СвернутыеПриглашения.Свернуть("ИдентификаторОрганизации,ИдентификаторКонтрагента");
	КоличествоПосле = СвернутыеПриглашения.Количество();
	Если КоличествоДо <> КоличествоПосле Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(
			НСтр(
			"ru = 'В записываемом наборе приглашений есть не уникальные приглашения по идентификаторам организации и контрагента.'"));
		Возврат;
	КонецЕсли;

КонецПроцедуры

Процедура ОчиститьДублиВСуществующихЗаписях()

	УстановитьПривилегированныйРежим(Истина);

	ПроверяемыеПриглашения = ЭтотОбъект.Выгрузить( , "Ключ,ИдентификаторОрганизации,ИдентификаторКонтрагента");

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПроверяемыеПриглашения.Ключ КАК Ключ,
	|	ПроверяемыеПриглашения.ИдентификаторОрганизации КАК ИдентификаторОрганизации,
	|	ПроверяемыеПриглашения.ИдентификаторКонтрагента КАК ИдентификаторКонтрагента
	|ПОМЕСТИТЬ ВТ_ПроверяемыеПриглашения
	|ИЗ
	|	&ПроверяемыеПриглашения КАК ПроверяемыеПриглашения
	|ГДЕ
	|	ПроверяемыеПриглашения.ИдентификаторОрганизации <> """"
	|	И ПроверяемыеПриглашения.ИдентификаторКонтрагента <> """"
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ключ,
	|	ИдентификаторОрганизации,
	|	ИдентификаторКонтрагента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПриглашенияНаИдентификаторы.Ключ КАК КлючСуществующего,
	|	ВТ_ПроверяемыеПриглашения.Ключ КАК КлючЗаписываемого,
	|	ПриглашенияНаИдентификаторы.ИдентификаторОрганизации,
	|	ПриглашенияНаИдентификаторы.ИдентификаторКонтрагента
	|ИЗ
	|	ВТ_ПроверяемыеПриглашения КАК ВТ_ПроверяемыеПриглашения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПриглашенияКОбменуЭлектроннымиДокументами КАК ПриглашенияНаИдентификаторы
	|		ПО ВТ_ПроверяемыеПриглашения.ИдентификаторОрганизации = ПриглашенияНаИдентификаторы.ИдентификаторОрганизации
	|		И ВТ_ПроверяемыеПриглашения.ИдентификаторКонтрагента = ПриглашенияНаИдентификаторы.ИдентификаторКонтрагента
	|		И ВТ_ПроверяемыеПриглашения.Ключ <> ПриглашенияНаИдентификаторы.Ключ";

	Запрос.УстановитьПараметр("ПроверяемыеПриглашения", ПроверяемыеПриглашения);

	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ПриглашенияКОбменуЭлектроннымиДокументами.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Ключ.Установить(ВыборкаДетальныеЗаписи.КлючСуществующего);
		НаборЗаписей.Отбор.ИдентификаторОрганизации.Установить(ВыборкаДетальныеЗаписи.ИдентификаторОрганизации);
		НаборЗаписей.Записать();
	КонецЦикла;

	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

#КонецОбласти

#КонецЕсли