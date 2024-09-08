﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
// Возвращаемое значение:
// 	СтрокаТаблицыЗначений
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.УсловияПродаж) 
			И ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") 
			И ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25() Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.УсловияПродаж2_5.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Условия продаж'");
		
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "Важное";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "УсловияПродаж");
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//
// Возвращаемое значение:
//  Неопределено, СтрокаТаблицыЗначений - команда отчета
Функция ДобавитьКомандуОтчетаПоПартнеру(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.УсловияПродаж) 
			И ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") 
			И ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25() Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.УсловияПродаж2_5.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Условия продаж клиенту'");
		
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Важное";
		КомандаОтчет.ФункциональныеОпции = "ИспользоватьДанныеПартнераКлиентаКонтекст";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "УсловияПродажПоПартнеру");
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли