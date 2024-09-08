﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.СистемаБыстрыхПлатежей.ПереводыСБПc2b".
// ОбщийМодуль.ИнтеграцияСПлатежнымиСистемамиКлиент.
//
// Устаревшие клиентские процедуры.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать СистемаБыстрыхПлатежейКлиент.НастройкиПодключения.
//
Процедура НастройкиИнтеграции(Владелец) Экспорт
	
	СистемаБыстрыхПлатежейКлиент.НастройкиПодключения(
		Владелец);
	
КонецПроцедуры

// Устарела. Следует использовать СистемаБыстрыхПлатежейКлиент.ПодключитьСистемуБыстрыхПлатежей.
//
Процедура ПодключитьИнтеграциюССБП(
		БИК = Неопределено,
		ОписаниеОповещения = Неопределено,
		ДополнительныеПараметры = Неопределено,
		ОтборУчастников = Неопределено) Экспорт
	
	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("БИК", БИК);
	ПараметрыПодключения.Вставить("ОтборУчастников", ОтборУчастников);
	
	СистемаБыстрыхПлатежейКлиент.ПодключитьСистемуБыстрыхПлатежей(
		ПараметрыПодключения,
		ОписаниеОповещения,
		ДополнительныеПараметры);
	
КонецПроцедуры

// Устарела. Следует использовать СистемаБыстрыхПлатежейКлиент.ОтправитьСообщениеВСлужбуТехническойПоддержки.
//
Процедура ОтправитьСообщениеВСлужбуТехническойПоддержки(
		ДокументОперации,
		ТорговаяТочка,
		ТекстСообщения = "") Экспорт
	
	СистемаБыстрыхПлатежейКлиент.ОтправитьСообщениеВСлужбуТехническойПоддержки(
		ДокументОперации,
		ТорговаяТочка,
		ТекстСообщения);
	
КонецПроцедуры

// Устарела. Следует использовать ПереводыСБПc2bКлиент.РеестрОперацийСБПc2b.
//
Процедура РеестрОперацийСБПc2b(Владелец) Экспорт
	
	ПереводыСБПc2bКлиент.РеестрОперацийСБПc2b(
		Владелец);
	
КонецПроцедуры

// Устарела. Следует использовать СистемаБыстрыхПлатежейКлиент.ФормаПользовательскогоСоглашения.
//
Процедура ФормаПользовательскогоСоглашения(ВладелецФормы = Неопределено) Экспорт
	
	СистемаБыстрыхПлатежейКлиент.ФормаПользовательскогоСоглашения(
		ВладелецФормы);
	
КонецПроцедуры

// Устарела. Следует использовать ПереводыСБПc2bКлиент.ОткрытьИнструкциюПоПрограммированиюNFCМетки.
//
Процедура ОткрытьИнструкциюПоПрограммированиюNFCМетки() Экспорт
	
	ПереводыСБПc2bКлиент.ОткрытьИнструкциюПоПрограммированиюNFCМетки();
	
КонецПроцедуры

// Устарела. Следует использовать ПереводыСБПc2bКлиент.ОткрытьОписаниеКассовыхСсылок.
//
Процедура ОткрытьОписаниеКассовыхСсылок() Экспорт
	
	ПереводыСБПc2bКлиент.ОткрытьОписаниеКассовыхСсылок();
	
КонецПроцедуры

// Устарела. Следует использовать ПереводыСБПc2bКлиент.ПодключитьКассовуюСсылку.
//
Процедура ПодключитьКассовуюСсылку(
		НастройкаПодключения,
		ОписаниеОповещение,
		Владелец) Экспорт
	
	ПереводыСБПc2bКлиент.ПодключитьКассовуюСсылку(
		НастройкаПодключения,
		ОписаниеОповещение,
		Владелец);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти