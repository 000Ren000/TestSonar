﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.СистемаБыстрыхПлатежей.ПереводыСБПc2b".
// ОбщийМодуль.ПереводыСБПc2bКлиент.
//
// Клиентские процедуры переводов СБП (c2b):
//  - Переход к инструкциям и отчетам.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму подключения кассовой ссылки.
//
// Параметры:
//  НастройкаПодключения - СправочникСсылка.НастройкиПодключенияКСистемеБыстрыхПлатежей - настройка выполнения оплаты.
//  ОписаниеОповещение - ОписаниеОповещение, Неопределенно - оповещение, которое будет вызвано после завершения операции.
//   Если подключение не удалось завершить будет возвращено Неопределенно. В случае успешного подключения
//   результат выполнения будет содержать структуру:
//    * КассоваяСсылка - Строка - ссылка, по которой будет выполнятся оплата;
//    * ИдентификаторОплаты - Строка - идентификатор зарегистрированной ссылки;
//  Владелец - ФормаКлиентскогоПриложения - форма которая будет установлена в качестве владельца. 
//
Процедура ПодключитьКассовуюСсылку(
		НастройкаПодключения,
		ОписаниеОповещение,
		Владелец) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НастройкаПодключения", НастройкаПодключения);
	
	ОткрытьФорму(
		"ОбщаяФорма.ПодключениеКассовойСсылки",
		ПараметрыФормы,
		Владелец,
		,
		,
		,
		ОписаниеОповещение);
	
КонецПроцедуры

// Открывает форму реестра операций.
//
// Параметры:
//  Владелец - ФормаКлиентскогоПриложения - форма которая будет установлена в качестве владельца.
//
Процедура РеестрОперацийСБПc2b(Владелец) Экспорт
	
	ОткрытьФорму(
		"Отчет.РеестрОперацийСБПc2b.ФормаОбъекта",
		,
		Владелец);
	
КонецПроцедуры

// Открывает инструкцию по программированию NFC меток.
//
Процедура ОткрытьИнструкциюПоПрограммированиюNFCМетки() Экспорт
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(
		"https://downloads.v8.1c.ru/content/Instruction/programming-NFC-tags.pdf");
	
КонецПроцедуры

// Открывает описание функциональности кассовых ссылок.
//
Процедура ОткрытьОписаниеКассовыхСсылок() Экспорт
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(
		"https://v8.1c.ru/cash-qrs");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. ОтчетыКлиентПереопределяемый.ОбработкаВыбораТабличногоДокумента.
//
Процедура ПриОбработкеВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка) Экспорт
	
	Если ТипЗнч(Область) = Тип("РисунокТабличногоДокумента")
		Или Область.ТипОбласти <> ТипОбластиЯчеекТабличногоДокумента.Прямоугольник Тогда
		Возврат;
	КонецЕсли;
	
	Если Область.Расшифровка = "ПодключитьИнтернетПоддержкуПользователейРеестрСБП" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ФормаОтчета", ФормаОтчета);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПослеПодключенияИнтернетПоддержкиПользователей",
			ЭтотОбъект,
			ДополнительныеПараметры);
		
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
			ОписаниеОповещения,
			ФормаОтчета);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет формирование отчета после ввода данных аутентификации.
//
// Параметры:
//  Результат - Строка - результат ввода логина и пароля;
//  ДополнительныеПараметры - Структура - дополнительные параметры.
//
Процедура ПослеПодключенияИнтернетПоддержкиПользователей(
		Результат,
		ДополнительныеПараметры) Экспорт
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		ВызватьИсключение НСтр("ru = 'Не внедрена подсистема ""Варианты отчетов"".'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Результат) Тогда
		МодульОтчетыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОтчетыКлиент");
		МодульОтчетыКлиент.СформироватьОтчет(ДополнительныеПараметры.ФормаОтчета);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму списка шаблонов сообщений.
//
// Параметры:
//  УникальныйИдентификатор - УникальныйИдентификатор - ключ уникальности используемый при открытии формы.
//
Процедура ОткрытьШаблоныСообщенийСБП(УникальныйИдентификатор) Экспорт
	
	РезультатПроверки = ПереводыСБПc2bВызовСервера.ВсеШаблоныСозданы();
	
	Если РезультатПроверки.ВсеШаблоны Тогда
		ОткрытьФормуШаблонаСообщенийСОтбором(
			РезультатПроверки.МассивШаблонов,
			УникальныйИдентификатор);
	Иначе
		РезультатПроверки.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
		
		Оповещение = Новый ОписаниеОповещения(
			"ПослеОтветаНаВопросОСозданииШаблонов",
			ЭтотОбъект,
			РезультатПроверки);
		
		ПоказатьВопрос(
			Оповещение,
			НСтр("ru = 'Создать шаблоны сообщений для автоматического заполнения на основании данных документов?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

// Вызывает открытие формы кассовых ссылок из формы настройки подключения СБП.
//
// Параметры:
//  ПараметрыНастройки - Структура - содержит в себе описание настроек подключения:
//    * НастройкаПодключения - СправочникСсылка.НастройкиПодключенияКСистемеБыстрыхПлатежей -
//      настройка подключения к Системе быстрых платежей.
//  ОповещениеПослеЗакрытияФормы - ОписаниеОповещения - оповещение,вызывает метод "ПриЗакрытииФормыКассовыхСсылок",
//    необходимо передать количество кассовых ссылок по настройке интеграции.
//
Процедура ПриНастройкеКассовыхСсылок(
		ПараметрыНастройки,
		ОповещениеПослеЗакрытияФормыКассовыхСсылок) Экспорт
	
	ПараметрыОплаты = СистемаБыстрыхПлатежейВызовСервера.ПараметрыОплатыПоНастройке(
		ПараметрыНастройки.НастройкаПодключения);
	
	ИнтеграцияПодсистемБИПКлиент.ПриНастройкеКассовыхСсылок(
		ПараметрыНастройки,
		ПараметрыОплаты,
		ОповещениеПослеЗакрытияФормыКассовыхСсылок);
	
	ПереводыСБПc2bКлиентПереопределяемый.ПриНастройкеКассовыхСсылок(
		ПараметрыНастройки,
		ПараметрыОплаты,
		ОповещениеПослеЗакрытияФормыКассовыхСсылок);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПодготовкаПлатежнойСсылки

// См. ПереводыСБПc2bСлужебный.ПриОпределенииКомандПодключенныхКОбъекту
//
Процедура ПодключаемыйОткрытьФормуПлатежнойСсылкиСБП(
		ПараметрКоманды,
		ПараметрыВыполненияКоманды) Экспорт
		
	ИнтеграцияПодсистемБИПКлиент.ПередОткрытиемФормыОтправкиПлатежнойСсылки();
	ПереводыСБПc2bКлиентПереопределяемый.ПередОткрытиемФормыОтправкиПлатежнойСсылки();
	ОткрытьФормуПлатежнойСсылкиСБП(ПараметрКоманды);
	
КонецПроцедуры

// Открывает форму формирования ссылки на оплату.
// Позволяет: 
//  * Сформировать новую ссылку.
//  * Просмотреть сформированную ранее ссылку.
//  * Обновить данные в сервисе, если они изменились.
//  
// Параметры:
//  ОснованиеПлатежа - Произвольный - основание платежа, для которого нужно сформировать/открыть/обновить ссылку.
//
Процедура ОткрытьФормуПлатежнойСсылкиСБП(Знач ОснованиеПлатежа)
	
	Параметры = Новый Структура;
	Параметры.Вставить("ОснованиеПлатежа", ОснованиеПлатежа);
	
	ОбработкаПродолжения = Новый ОписаниеОповещения(
		"ОткрытьФормуПлатежнойСсылкиСБППродолжение",
		ЭтотОбъект,
		Параметры);
	
	СистемаБыстрыхПлатежейКлиент.НачатьПроверкуИПодключениеИнтернетПоддержкиПользователей(
		ОбработкаПродолжения);
	
	КонецПроцедуры

// Подготавливает параметры открытия формы формирования платежной ссылки основания платежа.
// Перед открытием проверяется наличие подключенной интернет-поддержки пользователей.
//
// Параметры:
//  ПодключенаИПП - Булево - признак подключения ИПП.
//  Параметры - Структура - содержит описание параметров открытия формы:
//   * ОснованиеПлатежа - Произвольный - основание платежа, для которого будет формироваться ссылка.
//
Процедура ОткрытьФормуПлатежнойСсылкиСБППродолжение(
		Знач ПодключенаИПП,
		Знач Параметры) Экспорт
	
	Если Не ПодключенаИПП Тогда
		Возврат;
	КонецЕсли;
	
	РезультатПроверки = ПереводыСБПc2bВызовСервера.ПриОпределенииДоступностиПодключенияПоДокументуОперации(
		Параметры.ОснованиеПлатежа);
	
	Если Не РезультатПроверки.ИнтеграцияДоступна Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатПроверки.СообщениеОбОшибке);
		Возврат;
	КонецЕсли;
	
	ПараметрыНастройки =
		ПереводыСБПc2bВызовСервера.ПриОпределенииПараметровПодключенияДокументаОперации(
			Параметры.ОснованиеПлатежа);
	
	Если ПараметрыНастройки.ПараметрыВопроса.ТекстВопроса <> Неопределено Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ПараметрыНастройки", ПараметрыНастройки);
		ДополнительныеПараметры.Вставить("Параметры", Параметры);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОткрытьФормуПлатежнойСсылкиСБППослеОтвета",
			ЭтотОбъект,
			ДополнительныеПараметры);
		
		ПоказатьВопрос(
			ОписаниеОповещения,
			ПараметрыНастройки.ПараметрыВопроса.ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
			
	Иначе
		ОткрытьФормуПлатежнойСсылкиСБППослеОтветаЗавершение(
			ПараметрыНастройки,
			Параметры)
	КонецЕсли;
	
КонецПроцедуры

// Определяет поведение системы после ответа пользователя о создании новой торговой точки.
//
// Параметры:
//  Ответ - Структура - результат открытия окна с вопросом пользователю.
//  Параметры - Структура - содержит описание параметров открытия формы.
//
Процедура ОткрытьФормуПлатежнойСсылкиСБППослеОтвета(
		Ответ,
		ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОткрытьФормуПлатежнойСсылкиСБППослеОтветаЗавершение(
			ДополнительныеПараметры.ПараметрыНастройки,
			ДополнительныеПараметры.Параметры)
	КонецЕсли;
	
КонецПроцедуры

// Определяет поведение системы после ответа пользователя о создании новой торговой точки.
//
// Параметры:
//  Параметры - Структура - параметры открытия.
//  ПараметрыНастройки - Структура - содержит описание параметров настройки.
//
Процедура ОткрытьФормуПлатежнойСсылкиСБППослеОтветаЗавершение(
		ПараметрыНастройки,
		Параметры)
	
	Если ЗначениеЗаполнено(ПараметрыНастройки.НастройкиПодключения) Тогда
		
		ОткрытьФормуПодготовкиПлатежнойСсылкиСБП(
			Параметры.ОснованиеПлатежа,
			ПараметрыНастройки.НастройкиПодключения,
			ПараметрыНастройки.ДополнительныеНастройки.МаксимальнаяСуммаОплаты);
		
	ИначеЕсли СистемаБыстрыхПлатежейВызовСервера.НастройкаПодключенияДоступна() Тогда
		
		ПараметрыЗавершения = Новый Структура;
		ПараметрыЗавершения.Вставить("ОснованиеПлатежа", Параметры.ОснованиеПлатежа);
		ПараметрыЗавершения.Вставить("НоваяНастройкаПодключения", Неопределено);
		
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ПараметрыЗавершения", ПараметрыЗавершения);
		ПараметрыОповещения.Вставить("НастройкиПодключения", ПараметрыНастройки.НастройкиПодключения);
		ПараметрыОповещения.Вставить("ДополнительныеНастройки", ПараметрыНастройки.ДополнительныеНастройки);
		
		ОбработкаОтвета = Новый ОписаниеОповещения(
			"ПоказатьВопросСозданияНастройкиПодключенияЗавершение",
			ЭтотОбъект,
			ПараметрыОповещения);
		
		ТекстВопроса = НСтр("ru='Настройка подключения к Системе быстрых платежей не
			|найдена, необходимо создать новую настройку.
			|Создать сейчас?'");
		
		ПоказатьВопрос(
			ОбработкаОтвета,
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
		
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не обнаружены настройки подключения к СБП'"));
	КонецЕсли;
	
КонецПроцедуры

// Определяет поведение системы после ответа пользователя о создании новой торговой точки.
//
// Параметры:
//  Ответ - Структура - результат открытия окна с вопросом пользователю.
//  Параметры - Структура - содержит описание параметров открытия формы.
//
Процедура ПоказатьВопросСозданияНастройкиПодключенияЗавершение(
		Знач Ответ,
		Знач Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"СозданиеНастройкиПодключенияЗавершение",
			ЭтотОбъект,
			Параметры.ПараметрыЗавершения);
			
		ПараметрыПодключения = СистемаБыстрыхПлатежейКлиент.НовыйПараметрыПодключения(
			Параметры.ДополнительныеНастройки.БИК,
			Параметры.ДополнительныеНастройки.ОтборУчастников);
		
		ПараметрыПодключения.Вставить(
			"НастройкаПодключения",
			Неопределено);
		ПараметрыПодключения.Вставить(
			"ДополнительныеПараметры",
			Параметры.ДополнительныеНастройки.ДополнительныеПараметры);
		ПараметрыПодключения.Вставить(
			"ОснованиеПлатежа",
			Параметры.ПараметрыЗавершения.ОснованиеПлатежа);
		
		СистемаБыстрыхПлатежейКлиент.СлужебнаяПодключитьСистемуБыстрыхПлатежей(
			ПараметрыПодключения,
			ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет вызов обработки оповещения после окончания процесса создания торговой точки
//
// Параметры:
//  Результат - КодВозвратаДиалога - Содержит ответ пользователя.
//  ДополнительныеПараметры - Структура - содержит описание оповещения при закрытии формы.
//
Процедура СозданиеНастройкиПодключенияЗавершение(
		Результат,
		ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено И Результат <> КодВозвратаДиалога.Отмена Тогда
		ПараметрыДокумента = 
			ПереводыСБПc2bВызовСервера.ПриОпределенииПараметровПодключенияДокументаОперации(
				ДополнительныеПараметры.ОснованиеПлатежа);
		Если ЗначениеЗаполнено(ПараметрыДокумента) Тогда
			ОткрытьФормуПодготовкиПлатежнойСсылкиСБП(
				ДополнительныеПараметры.ОснованиеПлатежа,
				ПараметрыДокумента.НастройкиПодключения,
				ПараметрыДокумента.ДополнительныеНастройки.МаксимальнаяСуммаОплаты);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму формирования платежной ссылки основания платежа.
// Перед открытием проверяется наличие подключенной интернет-поддержки пользователей.
//
// Параметры:
//  ОснованиеПлатежа - Произвольный - основание платежа, для которого будет формироваться ссылка.
//  НастройкаПодключения - СправочникСсылка.НастройкиПодключенияКСистемеБыстрыхПлатежей -
//    настройка выполнения операции.
//
Процедура ОткрытьФормуПодготовкиПлатежнойСсылкиСБП(
		ОснованиеПлатежа,
		НастройкиПодключения,
		МаксимальнаяСуммаОплаты)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ОснованиеПлатежа",        ОснованиеПлатежа);
	ПараметрыФормы.Вставить("НастройкиПодключения",    НастройкиПодключения);
	ПараметрыФормы.Вставить("МаксимальнаяСуммаОплаты", МаксимальнаяСуммаОплаты);
	
	ОткрытьФорму(
		"ОбщаяФорма.ОтправкаПлатежнойСсылкиСБПc2b",
		ПараметрыФормы);
		
КонецПроцедуры

// Определяет поведение системы после ответа пользователя о создании шаблонов
//
// Параметры:
//  Результат - Структура - результат открытия окна с вопросом пользователю.
//  Параметры - Структура - содержит описание параметров открытия формы.
//
Процедура ПослеОтветаНаВопросОСозданииШаблонов(
		Результат,
		Параметры) Экспорт
	
	МассивШаблонов = Параметры.МассивШаблонов;
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		
		ПереводыСБПc2bВызовСервера.УстановитьИспользованиеШаблоновСообщенийПроверкаПодсистем();
		
		МассивСозданныхШаблонов = ПереводыСБПc2bВызовСервера.СоздатьПредопределенныеШаблоныСообщенийПроверкаПодсистем();
		
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
			МассивШаблонов,
			МассивСозданныхШаблонов);
		
	КонецЕсли;
	
	ОткрытьФормуШаблонаСообщенийСОтбором(
		МассивШаблонов,
		Параметры.УникальныйИдентификатор);
	
КонецПроцедуры

// Осуществляет открытие формы шаблонов сообщений с отбором по предопределенным шаблонам подсистемы.
//
// Параметры:
//  МассивШаблонов - Массив из СправочникСсылка.ШаблоныСообщений - массив элементов по которым будет установлен отбор.
//  УникальныйИдентификатор - УникальныйИдентификатор - ключ уникальности используемый при открытии формы
//
Процедура ОткрытьФормуШаблонаСообщенийСОтбором(
		ДанныеШаблонов,
		УникальныйИдентификатор)
	
	ОтборФормы = Новый Структура();
	ОтборФормы.Вставить("Ссылка", ДанныеШаблонов);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Отбор", ОтборФормы);
	
	ИмяФормыСпискаШаблонов = "Справочник.ШаблоныСообщений.ФормаСписка";
	ОткрытьФорму(
		ИмяФормыСпискаШаблонов,
		ПараметрыФормы,
		ЭтотОбъект,
		УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
