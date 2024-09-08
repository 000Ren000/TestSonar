﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
// Возвращаемое значение:
//   СтрокаТаблицыЗначений - новая команда отчета.
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.УсловияЗакупок) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.УсловияЗакупок.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Условия закупок'");
		
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "Важное";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "УсловияЗакупок");
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
// Возвращаемое значение:
//   СтрокаТаблицыЗначений - новая команда отчета.
Функция ДобавитьКомандуОтчетаПоПоставщику(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.УсловияЗакупок) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.УсловияЗакупок.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Условия закупок по поставщику'");
		
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Важное";
		КомандаОтчет.ФункциональныеОпции = "ИспользоватьДанныеПартнераПоставщикаКонтекст,ИспользоватьДанныеПоставщикаИлиКонкурентаКонтекст";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "УсловияЗакупокПоПоставщику");
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли