﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВариантыОтчетов

// Настройки вариантов этого отчета.
// Подробнее - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	// Настройка размещения, видимости по умолчанию, важности
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "Основной");
	ВариантыОтчетовУТПереопределяемый.УстановитьВажностьВариантаОтчета(ОписаниеВарианта, "СмТакже");
	
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ПоКонтактнымЛицам");
	ВариантыОтчетовУТПереопределяемый.УстановитьВажностьВариантаОтчета(ОписаниеВарианта, "СмТакже");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   
// Возвращаемое значение:
//   СтрокаТаблицыЗначений - описание команды отчета
//
Функция ДобавитьКомандуКонтактнаяИнформацияПоПартнерам(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.КонтактнаяИнформация) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.КонтактнаяИнформация.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Контактная информация'");
		
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет["Важность"]         = "Важное";
		КомандаОтчет.ФункциональныеОпции = "ИспользоватьРолиКонтактныхЛицПартнеров";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции


// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   
// Возвращаемое значение:
//   СтрокаТаблицыЗначений - описание команды отчета
//
Функция ДобавитьКомандуКонтактнаяИнформацияКонтактныхЛиц(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.КонтактнаяИнформация) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.КонтактнаяИнформация.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Контактная информация контактных лиц'");
		КомандаОтчет.КлючВарианта = "ПоКонтактнымЛицам";
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет["Важность"] = "Важное";
		КомандаОтчет.ФункциональныеОпции = "ИспользоватьРолиКонтактныхЛицПартнеров";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции


#КонецОбласти

#КонецОбласти

#КонецЕсли