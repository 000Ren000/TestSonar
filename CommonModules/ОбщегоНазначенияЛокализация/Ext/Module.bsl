﻿#Область ПрограммныйИнтерфейс

// Определяет объекты метаданных и отдельные реквизиты, которые исключаются из результатов поиска ссылок,
// не учитываются при монопольном удалении помеченных, замене ссылок и в отчете по местам использования.
//
// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииИсключенийПоискаСсылок
//
Процедура ПриДобавленииИсключенийПоискаСсылок(ИсключенияПоискаСсылок) Экспорт
	
	//++ Локализация


	//-- Локализация
	
КонецПроцедуры

// Определяет соответствие имен параметров сеанса и обработчиков для их установки.
//
// В указанных модулях должна быть размещена процедура обработчика, в которую передаются параметры
//  ИмяПараметра           - Строка - имя параметра сеанса, который требуется установить.
//  УстановленныеПараметры - Массив - имена параметров, которые уже установлены.
// 
// Далее пример процедуры обработчика для копирования в указанные модули.
//
// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииОбработчиковУстановкиПараметровСеанса.
//
Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	
	//++ Локализация
	
	// ИнтеграцияЕГАИС
	Обработчики.Вставить("ИдентификаторСеансаЕГАИС" , "ИнтеграцияЕГАИС.УстановитьПараметрыСеанса");
	// Конец ИнтеграцияЕГАИС
	Обработчики.Вставить("ПараметрыЛогированияЗапросовИСМП",   "ОбщегоНазначенияИСМП.УстановитьПараметрыСеанса");
	Обработчики.Вставить("ПараметрыЛогированияЗапросовЗЕРНО",  "ИнтеграцияЗЕРНО.УстановитьПараметрыСеанса");
	Обработчики.Вставить("ПараметрыЛогированияЗапросовВЕТИС",  "ИнтеграцияВЕТИС.УстановитьПараметрыСеанса");
	Обработчики.Вставить("ПараметрыЛогированияЗапросовСАТУРН", "ИнтеграцияСАТУРН.УстановитьПараметрыСеанса");
	Обработчики.Вставить("ДанныеКлючаСессииИСМП",              "ОбщегоНазначенияИСМП.УстановитьПараметрыСеанса");
	Обработчики.Вставить("ДанныеКлючаСессииИСМПРозница",       "ОбщегоНазначенияИСМП.УстановитьПараметрыСеанса");
	Обработчики.Вставить("ДанныеКлючаСессииСАТУРН",            "ИнтеграцияСАТУРН.УстановитьПараметрыСеанса");
	Обработчики.Вставить("CDNПлощадкиСОшибкамиОбменаИСМП",     "ОбщегоНазначенияИСМП.УстановитьПараметрыСеанса");
	
	// ИнтернетПоддержкаПользователей
	ИнтеграцияПодсистемБИП.ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики);
	// Конец ИнтернетПоддержкаПользователей
	
	
	// ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействие.ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики);
	// Конец ЭлектронноеВзаимодействие
	
	//-- Локализация
	
	Возврат;
	
КонецПроцедуры

// Позволяет задать значения параметров, необходимых для работы клиентского кода
// конфигурации без дополнительных серверных вызовов.
// 
// см. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиента
//
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
	//++ Локализация
	// ИнтернетПоддержкаПользователей
	ИнтеграцияПодсистемБИП.ПриДобавленииПараметровРаботыКлиента(Параметры);
	// Конец ИнтернетПоддержкаПользователей
	
	
	ОбщегоНазначенияИС.ПриДобавленииПараметровРаботыКлиента(Параметры);
	
	//-- Локализация
	Возврат;
	
КонецПроцедуры

// см. ОбщегоНазначенияПереопределяемый.ПередЗапускомПрограммы
Процедура ПередЗапускомПрограммы() Экспорт
	
	//++ Локализация
	
	// ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействие.ПередЗапускомПрограммы();
	// Конец ЭлектронноеВзаимодействие
	
	// Маг1С
	Маг1ССервер.ПередЗапускомПрограммы();
	// Конец Маг1С
	
	//-- Локализация
	
КонецПроцедуры

// Позволяет задать значения параметров, необходимых для работы клиентского кода
// при запуске конфигурации (в обработчиках событий ПередНачаломРаботыСистемы и ПриНачалеРаботыСистемы) 
// без дополнительных серверных вызовов. 
// 
// см. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиентаПриЗапуске
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	//++ Локализация
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
	
		// ИнтернетПоддержкаПользователей
		ИнтеграцияПодсистемБИП.ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры);
		// Конец ИнтернетПоддержкаПользователей
		
		// ЭлектронноеВзаимодействие
		ЭлектронноеВзаимодействие.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
		// Конец ЭлектронноеВзаимодействие
		
		
		ИнтеграцияЕГАИС.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
		
	КонецЕсли;
	
	//-- Локализация
	Возврат;
	
КонецПроцедуры

// Вызывается при обновлении информационной базы для учета переименований подсистем и ролей в конфигурации.
//  
// см. ОбщегоНазначенияПереопределяемый.ПриДобавленииПереименованийОбъектовМетаданных
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт

	//++ Локализация

	
	// ИнтернетПоддержкаПользователей
	ИнтеграцияПодсистемБИП.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	// Конец ИнтернетПоддержкаПользователей
	
	// ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействие.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	// Конец ЭлектронноеВзаимодействие
	//-- Локализация
	Возврат;

КонецПроцедуры

// Определяет список версий программных интерфейсов, доступных через web-сервис InterfaceVersion.
// 
// См. ОбщегоНазначенияПереопределяемый.ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(ПоддерживаемыеВерсии) Экспорт

	//++ Локализация


	//-- Локализация
	Возврат;
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииСерверныхОповещений
Процедура ПриДобавленииСерверныхОповещений(Оповещения) Экспорт

	//++ Локализация
	
	// ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействие.ПриДобавленииСерверныхОповещений(Оповещения);
	// Конец ЭлектронноеВзаимодействие
	
	ИнтеграцияЗЕРНО.ПриДобавленииСерверныхОповещений(Оповещения);
	
	// ИнтеграцияСМаркетплейсами
	ИнтеграцияСМаркетплейсамиСервер.ПриДобавленииСерверныхОповещений(Оповещения);
	// Конец ИнтеграцияСМаркетплейсами
	
	//-- Локализация
	
КонецПроцедуры

//см. ОбщегоНазначенияПереопределяемый.ПриПериодическомПолученииДанныхКлиентаНаСервере
Процедура ПриПериодическомПолученииДанныхКлиентаНаСервере(Параметры, Результаты) Экспорт
	
	//++ Локализация
	
	ИнтеграцияЗЕРНО.ПриПериодическомПолученииДанныхКлиентаНаСервере(Параметры, Результаты);
	ОбщегоНазначенияЕГАИС.ПриПериодическомПолученииДанныхКлиентаНаСервере(Параметры, Результаты);
	
	//-- Локализация
	
КонецПроцедуры

#Область УстаревшиеПроцедурыИФункции

// см. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиентаПриЗапуске
//
Процедура ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт

	//++ Локализация
	// ИнтернетПоддержкаПользователей
	ИнтеграцияПодсистемБИП.ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры);
	// Конец ИнтернетПоддержкаПользователей
	

	//-- Локализация

КонецПроцедуры

// см. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиента
//
Процедура ПараметрыРаботыКлиента(Параметры) Экспорт
	
	//++ Локализация
	// ИнтернетПоддержкаПользователей
	ИнтеграцияПодсистемБИП.ПриДобавленииПараметровРаботыКлиента(Параметры);
	// Конец ИнтернетПоддержкаПользователей
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
