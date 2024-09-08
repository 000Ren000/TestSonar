﻿
#Область ПрограммныйИнтерфейс

// Открыть форму с результатом проверки документа на соответствие требованиям ГИСМТ.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
Процедура ОткрытьФормуСРезультатомПроверкиДокументаНаСоответствиеТребованиямГИСМТ(Форма) Экспорт
	
	Настройки = Форма.ПараметрыИнтеграцииГосИС.Получить("СоответствиеТребованиямГИСМТ");
	
	Если Настройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект = Форма[Настройки.ИмяРеквизитаФормыОбъект];
	
	Документ = Объект.Ссылка;
	Если Не ЗначениеЗаполнено(Документ) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Форма",    Форма);
	ПараметрыОповещения.Вставить("Документ", Документ);
	ПараметрыОповещения.Вставить("ЭтоФоноваяПроверкаДокумента", Ложь);
	ПараметрыОповещения.Вставить("ДополнитьРезультатДаннымиКомандыФормы", Истина);
	
	Если Форма.Модифицированность Тогда
		
		ТекстВопроса = НСтр("ru='Для продолжения нужно записать документ. Записать?'");
		
		Оповещение = Новый ОписаниеОповещения("ОткрытьФормуСРезультатомПроверкиДокументаНаСоответствиеТребованиямГИСМТПродолжить", ЭтотОбъект, ПараметрыОповещения);
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена,,
			КодВозвратаДиалога.Отмена, НСтр("ru='Необходимо записать документ'"));
		
		Возврат;
	КонецЕсли;
	
	ПроверитьДокументНаСоответствиеТребованиямГИСМТ(ПараметрыОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьФормуРезультатыПроверкиНаСоответствиеТребованиямГИСМТ(Организации = Неопределено, Владелец = Неопределено) Экспорт
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Организации", Организации);
	ОткрытьФорму("РегистрСведений.РезультатыОбработкиДокументовИСМП.Форма.ФормаРезультатыПроверки", ПараметрыОткрытияФормы, Владелец);
	
КонецПроцедуры

Процедура ПослеЗаписи(Форма, ПараметрыЗаписи) Экспорт
	
	// Запуск проверки документа в фоне
	
	Настройки = Форма.ПараметрыИнтеграцииГосИС.Получить("СоответствиеТребованиямГИСМТ");
	
	Если Настройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Настройки.ЗапуститьПроверкуДокументаВФоне Тогда
		ПодключитьОбработчикОжиданияПроверкиВыполненияЗадания(Форма);
	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьВыполнениеЗадания(Форма, ДополнительныеПараметры = Неопределено) Экспорт
	
	Настройки = Форма.ПараметрыИнтеграцииГосИС.Получить("СоответствиеТребованиямГИСМТ");
	
	Если Настройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Настройки.Свойство("ФоноваяПроверкаДокумента")
		И ЗначениеЗаполнено(Настройки.ФоноваяПроверкаДокумента.ИдентификаторЗадания) Тогда
		
		Результат = СоответствиеТребованиямГИСМТВызовСервера.СостояниеФоновойПроверкиДокумента(
		Настройки.ФоноваяПроверкаДокумента.ИдентификаторЗадания,
		Настройки.ФоноваяПроверкаДокумента.АдресРезультата);
		
		Если Результат <> Неопределено И Результат.Статус = "Выполняется" Тогда
			ПодключитьОбработчикОжиданияПроверкиВыполненияЗадания(Форма, Настройки.ИнтервалОбработкиОжидания);
		Иначе
			ПослеЗавершенияФоновогоЗадания(Результат, Форма, Настройки);
		КонецЕсли;
		
	ИначеЕсли Настройки.ЗапуститьПроверкуДокументаВФоне Тогда
		
		ПроверитьДокументНаСоответствиеТребованиямГИСМТВФоне(Форма, Настройки);
		
	ИначеЕсли Настройки.Свойство("ФоноваяПроверкаДокумента") Тогда
		
		Настройки.Удалить("ФоноваяПроверкаДокумента");
		
	КонецЕсли;
	
	Настройки.ЗапуститьПроверкуДокументаВФоне = Ложь;
	
КонецПроцедуры

Процедура ПроверитьДокументНаСоответствиеТребованиямГИСМТВФоне(Форма, Настройки)
	
	Объект = Форма[Настройки.ИмяРеквизитаФормыОбъект];
	
	Документ = Объект.Ссылка;
	Если Не ЗначениеЗаполнено(Документ) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроверки = Новый Структура;
	ПараметрыПроверки.Вставить("Документ",                    Документ);
	ПараметрыПроверки.Вставить("УникальныйИдентификатор",     Форма.УникальныйИдентификатор);
	ПараметрыПроверки.Вставить("ЭтоФоноваяПроверкаДокумента", Истина);
	ПараметрыПроверки.Вставить("ДополнитьРезультатДаннымиКомандыФормы", Истина);
	
	ПроверитьДокументНаСоответствиеТребованиямГИСМТЗапуститьВФоне(ПараметрыПроверки, Форма, Настройки);
	
КонецПроцедуры

Процедура ОткрытьФормуСРезультатомПроверкиДокументаНаСоответствиеТребованиямГИСМТПродолжить(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		ПараметрыОповещения.Форма.Записать();
		
		ПроверитьДокументНаСоответствиеТребованиямГИСМТ(ПараметрыОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДокументНаСоответствиеТребованиямГИСМТ(ВходныеДанные) Экспорт
	
	ПараметрыПроверки = Новый Структура;
	ПараметрыПроверки.Вставить("Документ",                              ВходныеДанные.Документ);
	ПараметрыПроверки.Вставить("УникальныйИдентификатор",               ВходныеДанные.Форма.УникальныйИдентификатор);
	ПараметрыПроверки.Вставить("ФоноваяПроверкаДокумента",              Истина);
	ПараметрыПроверки.Вставить("ДополнитьРезультатДаннымиКомандыФормы", ВходныеДанные.ДополнитьРезультатДаннымиКомандыФормы);
	ПараметрыПроверки.Вставить("ЭтоФоноваяПроверкаДокумента",           ВходныеДанные.ЭтоФоноваяПроверкаДокумента);
	ПараметрыПроверки.Вставить("ЗапуститьПовторнуюПроверку",            ВходныеДанные.Свойство("ЗапуститьПовторнуюПроверку"));
	
	ОписаниеЗавершения = Новый ОписаниеОповещения(
		"ПослеПроверкиДокументаНаСоответствиеТребованиямГИСМТ",
		ЭтотОбъект,
		ВходныеДанные);
	
	ПроверитьДокументНаСоответствиеТребованиямГИСМТПродолжение(ПараметрыПроверки, ВходныеДанные.Форма, ОписаниеЗавершения);
	
КонецПроцедуры

#Область ОбработкаРезультатаПослеЗавершенияВыполненияВсехПроверок

Процедура ПослеПроверкиДокументаНаСоответствиеТребованиямГИСМТ(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Или Результат.РезультатПроверки = Неопределено Тогда
		Возврат;
	КонецЕсли;

	СоответствиеТребованиямГИСМТВызовСервера.ПослеПроверкиДокументаНаСоответствиеТребованиямГИСМТ(Результат.РезультатПроверки);

	Если ДополнительныеПараметры.Свойство("ПроверкаИзФормыСписка") И ДополнительныеПараметры.ПроверкаИзФормыСписка Тогда
		ДополнительныеПараметры.Форма.Элементы.Список.Обновить();
		Возврат;
	КонецЕсли;
	
	ОбновитьСостояниеГиперссылкиНаФорме(Результат.ТекущееСостояниеКомандыФормы, ДополнительныеПараметры.Форма);
	
	ЕстьОшибки = Результат.Свойство("ЕстьОшибки") И Результат.ЕстьОшибки;
	
	Если ДополнительныеПараметры.Свойство("ЗапуститьПовторнуюПроверку") И ЕстьОшибки
		И ДополнительныеПараметры.Свойство("ФормаОшибок") Тогда
		Оповестить("ЗаполнитьРезультатыПроверок", Результат.РезультатПроверки, Результат.Документ);
		Возврат;
	КонецЕсли;
	
	Если Не ЕстьОшибки Тогда
		Если ДополнительныеПараметры.Свойство("ФормаОшибок") Тогда
			ДополнительныеПараметры.ФормаОшибок.Закрыть();
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеПараметры.ЭтоФоноваяПроверкаДокумента Тогда
		ОткрытьФормуОтображенияОшибокРезультатовПроверок(
			Результат.РезультатПроверки,
			ДополнительныеПараметры.Форма,
			ДополнительныеПараметры.Документ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьСостояниеГиперссылкиНаФорме(ТекущееСостояниеКомандыФормы, Форма)
	
	Настройки = Форма.ПараметрыИнтеграцииГосИС.Получить("СоответствиеТребованиямГИСМТ");
	
	Если Настройки = Неопределено Тогда
		Возврат;
	ИначеЕсли Не Настройки.РазмещатьЭлементыИнтерфейса Тогда
		Возврат;
	КонецЕсли;
	
	КомандаФормы = Форма.Элементы[Настройки.ИмяКомандыСоответствиеТребованиямГИСМТ];
	Если КомандаФормы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КомандаФормы.Видимость  = ТекущееСостояниеКомандыФормы.Видимость;
	КомандаФормы.ЦветТекста = ТекущееСостояниеКомандыФормы.ЦветТекста;
	КомандаФормы.Заголовок  = ТекущееСостояниеКомандыФормы.Заголовок;
	КомандаФормы.Вид        = ВидКнопкиФормы[ТекущееСостояниеКомандыФормы.ВидКнопкиФормы];
КонецПроцедуры

Процедура ОткрытьФормуОтображенияОшибокРезультатовПроверок(РезультатПроверки, Форма, Документ)
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("РезультатПроверки", РезультатПроверки);
	ПараметрыОповещения.Вставить("Форма",             Форма);
	ПараметрыОповещения.Вставить("Документ",          Документ);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РезультатПроверки", РезультатПроверки);
	ПараметрыФормы.Вставить("Документ",          Документ);
	
	ОткрытьФорму("Обработка.ПроверкаДокументовИСМП.Форма.ОшибкиВыполнения",
		ПараметрыФормы,
		Форма,
		,,,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

Процедура ПроверитьДокументНаСоответствиеТребованиямГИСМТПродолжение(ПараметрыПроверки, Форма, ОписаниеЗавершения)
	
	Если ПараметрыПроверки.ЭтоФоноваяПроверкаДокумента Тогда
		Попытка
			// Если предварительно была запущена фоновая проверка документа, то отменяем её
			ПрерватьФоновуюПроверкуДокумента(Форма);
		Исключение
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
	Результат = РезультатПроверкиДокументаИСМП(ПараметрыПроверки);
	
	ОбработатьРезультатПроверкиДокумента(Результат, ПараметрыПроверки, Форма, ОписаниеЗавершения);
	
КонецПроцедуры

Процедура ПроверитьДокументНаСоответствиеТребованиямГИСМТЗапуститьВФоне(ПараметрыПроверки, Форма, Настройки) Экспорт
	
	Результат = РезультатПроверкиДокументаИСМП(ПараметрыПроверки);
	
	ФоновоеЗадание = Результат.ДлительнаяОперация;
	
	Если ФоновоеЗадание = Неопределено Или ФоновоеЗадание.Статус <> "Выполняется" Тогда
		// Обработка не требуется
		Возврат;
	КонецЕсли;
	
	ФоноваяПроверкаДокумента = Новый Структура;
	ФоноваяПроверкаДокумента.Вставить("ИдентификаторЗадания", ФоновоеЗадание.ИдентификаторЗадания);
	ФоноваяПроверкаДокумента.Вставить("АдресРезультата",      ФоновоеЗадание.АдресРезультата);
	
	Настройки.Вставить("ФоноваяПроверкаДокумента",            ФоноваяПроверкаДокумента);
	
	Настройки.ИнтервалОбработкиОжидания = 1;
	
	ПодключитьОбработчикОжиданияПроверкиВыполненияЗадания(Форма, Настройки.ИнтервалОбработкиОжидания);
	
КонецПроцедуры

Процедура ОбработатьРезультатПроверкиДокумента(Результат, ПараметрыПроверки, Форма, ОписаниеЗавершения)
	
	Если Результат.ДлительнаяОперация = Неопределено Тогда
		
		Если Результат.ТребуетсяОбновлениеКлючаСессии Тогда
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("ПараметрыПроверки",  ПараметрыПроверки);
			ДополнительныеПараметры.Вставить("ОписаниеЗавершения", ОписаниеЗавершения);
			ДополнительныеПараметры.Вставить("Организация",        Результат.Организация);
			ДополнительныеПараметры.Вставить("Форма",              Форма);
			
			ЗапроситьКлючСессииДляПроверкиДокументаИСМП(Результат.Организация, ДополнительныеПараметры);
			
			Возврат;
		
		КонецЕсли;
		
		ВыполнитьОбработкуОповещения(ОписаниеЗавершения, Результат);
		
	Иначе
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
		ПараметрыОжидания.ТекстСообщения             = НСтр("ru='Выполняется проверка документа на соответствие требованиям ГИС МТ'");
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
		ПараметрыОжидания.ВыводитьОкноОжидания       = Истина;
		ПараметрыОжидания.ВыводитьСообщения          = Истина;
		
		Если Результат.Ожидать <> Неопределено Тогда
			ПараметрыОжидания.Интервал = Результат.Ожидать;
		КонецЕсли;
		
		ПараметрыЗавершенияДлительнойОперации = Новый Структура;
		ПараметрыЗавершенияДлительнойОперации.Вставить("Форма",                   Форма);
		ПараметрыЗавершенияДлительнойОперации.Вставить("ПараметрыПроверки",       ПараметрыПроверки);
		ПараметрыЗавершенияДлительнойОперации.Вставить("ОповещениеПриЗавершении", ОписаниеЗавершения);
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(
			Результат.ДлительнаяОперация,
			Новый ОписаниеОповещения("ПослеЗавершенияДлительнойОперации", ЭтотОбъект, ПараметрыЗавершенияДлительнойОперации),
			ПараметрыОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗапроситьКлючСессииДляПроверкиДокументаИСМП(Организация, ДополнительныеПараметры)
	
	ОповещениеПриЗапросеКлючаСессии = Новый ОписаниеОповещения(
		"ПослеПолученияКлючаСессииДляПроверкиДокументаИСМП",
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	ИнтерфейсАвторизацииИСМПКлиент.ЗапроситьКлючСессии(
		ОбщегоНазначенияИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии(Организация),
		ОповещениеПриЗапросеКлючаСессии);
	
КонецПроцедуры

Процедура ПослеПолученияКлючаСессииДляПроверкиДокументаИСМП(Результат, ДополнительныеПараметры) Экспорт
	
	ОтказОтАвторизации = Ложь;
	ОшибкаАвторизации  = Ложь;
	
	Если ТипЗнч(Результат) <> Тип("Соответствие") Тогда
		
		ОтказОтАвторизации = Истина;
		
	Иначе
		
		РезультатАвторизации = Результат[ДополнительныеПараметры.Организация];
		
		Если РезультатАвторизации = Неопределено Тогда
			ОшибкаАвторизации = Истина;
			ТекстОшибки = НСтр("ru = 'Произошла ошибка при авторизации в ИС МП.'");
		ИначеЕсли РезультатАвторизации <> Истина Тогда
			ОшибкаАвторизации = Истина;
			ТекстОшибки = РезультатАвторизации;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОтказОтАвторизации Тогда
		
		//ЗакрытьФорму();
		
	ИначеЕсли ОшибкаАвторизации Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
		
	Иначе
		
		ПроверитьДокументНаСоответствиеТребованиямГИСМТПродолжение(
			ДополнительныеПараметры.ПараметрыПроверки,
			ДополнительныеПараметры.Форма,
			ДополнительныеПараметры.ОписаниеЗавершения);
		
	КонецЕсли;
	
КонецПроцедуры

Функция РезультатПроверкиДокументаИСМП(ПараметрыПроверки)
	
	Возврат СоответствиеТребованиямГИСМТВызовСервера.ПроверкаДокументаНаСоответствиеТребованиямГИСМТ(ПараметрыПроверки);
	
КонецФункции

Процедура ПослеЗавершенияДлительнойОперации(Результат, ДополнительныеПараметрыДлительнойОперации) Экспорт
	
	Если Результат = Неопределено Тогда // отменено пользователем
		Если ДополнительныеПараметрыДлительнойОперации.ОповещениеПриЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметрыДлительнойОперации.ОповещениеПриЗавершении);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Результат.Сообщения <> Неопределено Тогда
		Для каждого СообщениеПользователю Из Результат.Сообщения Цикл
			СообщениеПользователю.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ПодробноеПредставлениеОшибки);
		
		Возврат;
		
	ИначеЕсли Результат.Статус <> "Выполнено" Тогда
		
		Возврат;
		
	КонецЕсли;
	
	РезультатПроверкиГИСМТ = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	Форма                                     = ДополнительныеПараметрыДлительнойОперации.Форма;
	ПараметрыПроверки                         = ДополнительныеПараметрыДлительнойОперации.ПараметрыПроверки;
	ОписаниеЗавершения                        = ДополнительныеПараметрыДлительнойОперации.ОповещениеПриЗавершении;
	
	Если РезультатПроверкиГИСМТ.ТребуетсяОбновлениеКлючаСессии Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ПараметрыПроверки",  ПараметрыПроверки);
		ДополнительныеПараметры.Вставить("ОписаниеЗавершения", ОписаниеЗавершения);
		ДополнительныеПараметры.Вставить("Организация",        РезультатПроверкиГИСМТ.Организация);
		ДополнительныеПараметры.Вставить("Форма",              Форма);
		
		ЗапроситьКлючСессииДляПроверкиДокументаИСМП(РезультатПроверкиГИСМТ.Организация, ДополнительныеПараметры);
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеЗавершения, РезультатПроверкиГИСМТ);
	
КонецПроцедуры

Процедура ПослеЗавершенияФоновогоЗадания(Результат, Форма, Настройки)
	
	Настройки.Удалить("ФоноваяПроверкаДокумента");
	
	Если Результат = Неопределено Или Результат.Статус <> "Выполнено" Тогда
		// Обработка не требуется
		Возврат;
	КонецЕсли;
	
	РезультатПроверкиГИСМТ = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	Если РезультатПроверкиГИСМТ.ТребуетсяОбновлениеКлючаСессии Тогда
		// Обработка не требуется
		Возврат;
	КонецЕсли;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Форма",    Форма);
	ПараметрыОповещения.Вставить("ПроверкаИзФормыСписка", Настройки.Свойство("ПроверкаИзФормыСписка"));
	Если Не ПараметрыОповещения.ПроверкаИзФормыСписка Тогда
		ПараметрыОповещения.Вставить("Документ", Форма[Настройки.ИмяРеквизитаФормыОбъект].Ссылка);
	КонецЕсли;
	ПараметрыОповещения.Вставить("ЭтоФоноваяПроверкаДокумента", Истина);
	
	ПослеПроверкиДокументаНаСоответствиеТребованиямГИСМТ(РезультатПроверкиГИСМТ, ПараметрыОповещения);
	
КонецПроцедуры

Процедура ПрерватьФоновуюПроверкуДокумента(Форма)
	
	Настройки = Форма.ПараметрыИнтеграцииГосИС.Получить("СоответствиеТребованиямГИСМТ");
	
	Настройки.ЗапуститьПроверкуДокументаВФоне = Ложь;
	
	Если Настройки.Свойство("ФоноваяПроверкаДокумента")
		И ЗначениеЗаполнено(Настройки.ФоноваяПроверкаДокумента.ИдентификаторЗадания) Тогда
		
		СоответствиеТребованиямГИСМТВызовСервера.ПрерватьФоновуюПроверкуДокумента(
			Настройки.ФоноваяПроверкаДокумента.ИдентификаторЗадания);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодключитьОбработчикОжиданияПроверкиВыполненияЗадания(Форма, Интервал = 1, Однократно = Истина)
	Форма.ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗаданияИС", Интервал, Однократно);
	Интервал = Интервал*2;
КонецПроцедуры

#КонецОбласти
