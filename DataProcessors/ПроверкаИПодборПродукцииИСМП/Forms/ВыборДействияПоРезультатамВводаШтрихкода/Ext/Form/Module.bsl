﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаОтложитьПродукцию.Видимость = Ложь;
	
	ДобавитьОтсканированнуюУпаковку  = 2;
	
	ОбработатьИПроверитьПереданныеПараметры();
	СформироватьЗаголовокФормы();
	СформироватьИнформациюОРезультатахПоиска();
	СформироватьПредложенияДействий();
	
	ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";
	ИнтеграцияИС.НастроитьПодключаемоеОборудование(ЭтотОбъект, ПоддерживаемыеТипыПодключаемогоОборудования);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, ПоддерживаемыеТипыПодключаемогоОборудования);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если Не ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеСобытия = Новый Структура;
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие" , Событие);
	ОписаниеСобытия.Вставить("Данные"  , Данные);
	
	Результат = МенеджерОборудованияКлиент.ПолучитьСобытиеОтУстройства(ОписаниеСобытия);
	
	Если Результат <> Неопределено
		И Результат.Источник = "ПодключаемоеОборудование"
		И Результат.ИмяСобытия = "ScanData"
		И Найти(ПоддерживаемыеТипыПодключаемогоОборудования, "СканерШтрихкода") > 0 Тогда
		
		ДанныеШтрихкода = СобытияФормИСКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Результат.Параметр);
		ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияОтсканируйтеУпаковкуОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОтметитьЧтоУпаковкаБезУпаковки" Тогда
	
		Если ПустаяСтрока(ШтрихкодУпаковкиГдеДолжноБыть) Тогда
			
			ИзменитьКонтекстПроверки();
			
		ИначеЕсли РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены") Тогда
			
			ПереместитьУпаковкуВДругуюУпаковку(Неопределено);
			
		Иначе
			
			Элементы.ГруппаОтсканируйтеУпаковку.Видимость = Ложь;
			Элементы.ГруппаОтложитьУпаковку.Видимость     = Истина;
			
			Если СтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.Отложена") Тогда
				Элементы.ОтложитьУпаковку.Видимость       = Ложь;
				Элементы.ОтменаОтложитьУпаковку.Заголовок = НСтр("ru = 'Закрыть'");
			Иначе
				Элементы.ОтложитьУпаковку.КнопкаПоУмолчанию = Истина;
			КонецЕсли;
			
			Элементы.ДекорацияОтложитьУпаковку.Заголовок  = ТекстОтложите(ЭтотОбъект);
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОтсканируйтеУпаковкуПродукцииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОтметитьЧтоПродукцияНайденаВнеУпаковки" Тогда
		
		Если РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены")
			Или ПустаяСтрока(ШтрихкодУпаковкиГдеДолжноБыть) Тогда
			
			ПереместитьВПродукциюБезУпаковки(Истина);
			
		Иначе
			
			Элементы.ГруппаОтсканируйтеПродукцию.Видимость = Ложь;
			Элементы.ГруппаОтложитьПродукцию.Видимость     = Истина;
			
			Если СтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.Отложена") Тогда
				Элементы.ОтложитьПродукцию.Видимость       = Ложь;
				Элементы.ОтменаОтложитьПродукцию.Заголовок = НСтр("ru = 'Закрыть'");
			Иначе
				Элементы.ОтменаОтложитьПродукцию.КнопкаПоУмолчанию = Истина;
			КонецЕсли;
			
			Элементы.ДекорацияОтложитьПродукцию.Заголовок  = ТекстОтложите(ЭтотОбъект);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#Область ОтветыНаВопросы

&НаКлиенте
Процедура ДобавитьОтсканированнуюУпаковкуПриИзменении(Элемент)
	
	Если ДобавитьОтсканированнуюУпаковку = 0 Тогда
		
		СтруктураДействия = Новый Структура;
		СтруктураДействия.Вставить("ВидДействия",    "ДобавитьНовуюУпаковку");
		СтруктураДействия.Вставить("Штрихкод",       Штрихкод);
		СтруктураДействия.Вставить("ЗапомнитьВыбор", ЗапомнитьВыбор);
		
		Закрыть(СтруктураДействия);
		
	Иначе
		
		Элементы.ГруппаОтветНаВопросДобавитьУпаковку.ТолькоПросмотр = Истина;
		Элементы.ГруппаНеДобавлятьОтсканированнуюУпаковку.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеИСКлиент.ПоказатьВводШтрихкода(
		Новый ОписаниеОповещения("РучнойВводШтрихкодаЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтложитьУпаковку(Команда)
	
	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия", "ОтложитьНайденноеВДругоеМесте");
	СтруктураДействия.Вставить("Штрихкод",    Штрихкод);
	
	Закрыть(СтруктураДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВПродукциюБезУпаковки(ИзменятьКонтекстПроверки)
	
	Если ТипЗнч(ИзменятьКонтекстПроверки) = Тип("Булево") Тогда
		Значение = ИзменятьКонтекстПроверки;
	Иначе
		Значение = Ложь;
	КонецЕсли;
	
	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия",              "ПереместитьВПродукциюБезУпаковки");
	СтруктураДействия.Вставить("Штрихкод",                 Штрихкод);
	СтруктураДействия.Вставить("ИзменятьКонтекстПроверки", Значение);
	
	Закрыть(СтруктураДействия)
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьНовуюВПродукциюБезУпаковки(Команда)
	
	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия", "ПоместитьНовуюВПродукциюБезУпаковки");
	СтруктураДействия.Вставить("Штрихкод",    Штрихкод);
	
	Закрыть(СтруктураДействия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область НастройкаОтображения

#Область МаркируемаяПродукция

&НаКлиенте
Процедура ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияПродукции()

	ОжидаетсяСканированиеУпаковки = Ложь;
	
	Элементы.ГруппаПроблемыПослеСканированияПродукции.Видимость  = Ложь;
	Элементы.ГруппаОтсканируйтеПродукцию.Видимость               = Ложь;
	Элементы.ГруппаОтсканированнаяПродукцияНеПроверена.Видимость = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПовторноОтсканировалиУпаковкуПродукции()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияПродукции.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияПродукции.Видимость    = Истина;
	Элементы.ДекорацияОтсканированнаяПродукцияНеПроверена.Заголовок  = 
		НСтр("ru = 'Продукция отсканирована повторно.
		           |Требуется отсканировать упаковку, в которой найдена продукция.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканированнаяУпаковкаПродукцииНеНайдена()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияПродукции.Видимость    = Истина;
	Элементы.КартинкаПроблемыПослеСканированияПродукции.Видимость  = Ложь;
	Элементы.ДекорацияПроблемыПослеСканированияПродукции.Заголовок =
		НСтр("ru = 'Отсканированная упаковка в данных документа не найдена.
		           |Для проверки содержимого упаковки отсканируйте штрихкод упаковки заново.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканировалиКодМаркировкиВместоПродукции()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияПродукции.Видимость    = Истина;
	Элементы.КартинкаПроблемыПослеСканированияПродукции.Видимость  = Истина;
	Элементы.ДекорацияПроблемыПослеСканированияПродукции.Заголовок = 
		НСтр("ru = 'Отсканирован код маркировки.
		           |Требуется отсканировать упаковку, в которой обнаружена продукция.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканировалиКодDataMatrixВместоУпаковкиПродукции()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияПродукции.Видимость    = Истина;
	Элементы.КартинкаПроблемыПослеСканированияПродукции.Видимость  = Истина;
	Элементы.ДекорацияПроблемыПослеСканированияПродукции.Заголовок = 
		НСтр("ru = 'Отсканирован код ""DataMatrix"".
		           |Требуется отсканировать упаковку, в которой обнаружена маркируемая продукция.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПереместитьВПродукциюБезУпаковки()
	
	ОжидаетсяСканированиеУпаковки = Ложь;
	
	Элементы.ГруппаПроблемыПослеСканированияПродукции.Видимость = Ложь;
	Элементы.ГруппаОтсканируйтеПродукцию.Видимость              = Ложь;
	Элементы.ГруппаПереместитьВПродукциюБезУпаковки.Видимость   = Истина;
	Элементы.ПереместитьВПродукциюБезУпаковки.КнопкаПоУмолчанию = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьОтложитьПродукцию(Форма)
	
	Элементы = Форма.Элементы;
	
	Форма.ОжидаетсяСканированиеУпаковки = Ложь;
	
	Элементы.ГруппаПроблемыПослеСканированияПродукции.Видимость = Ложь;
	Элементы.ГруппаОтсканируйтеПродукцию.Видимость              = Ложь;
	
	Элементы.ГруппаОтложитьПродукцию.Видимость    = Истина;
	Элементы.ОтложитьПродукцию.КнопкаПоУмолчанию  = Истина;
	Элементы.ДекорацияОтложитьПродукцию.Заголовок = ТекстОтложите(Форма);

КонецПроцедуры

#КонецОбласти

#Область Упаковки

&НаКлиенте
Процедура ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияУпаковки()

	ОжидаетсяСканированиеУпаковки = Ложь;
	
	Элементы.ГруппаПовторноОтсканировали.Видимость              = Ложь;
	Элементы.ГруппаОтсканируйтеУпаковку.Видимость               = Ложь;
	Элементы.ГруппаПроблемыПослеСканированияУпаковки.Видимость  = Ложь;
	Элементы.ГруппаОтсканированнаяУпаковкаНеПроверена.Видимость = Истина;
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьОтложитьУпаковку(Форма)

	Элементы = Форма.Элементы;
	
	Форма.ОжидаетсяСканированиеУпаковки = Ложь;
	
	Элементы.ГруппаПовторноОтсканировали.Видимость             = Ложь;
	Элементы.ГруппаОтсканируйтеУпаковку.Видимость              = Ложь;
	Элементы.ГруппаПроблемыПослеСканированияУпаковки.Видимость = Ложь;
	Элементы.ГруппаОтложитьУпаковку.Видимость                  = Истина;
	Элементы.ОтложитьУпаковку.КнопкаПоУмолчанию                = Истина;
	Элементы.ДекорацияОтложитьУпаковку.Заголовок               = ТекстОтложите(Форма);

КонецПроцедуры 

&НаКлиенте
Процедура ПоказатьПовторноОтсканировалиУпаковку()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковки.Видимость = Ложь;
	Элементы.ГруппаПовторноОтсканировали.Видимость             = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканированнаяУпаковкаУпаковкиНеНайдена()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковки.Видимость    = Истина;
	Элементы.КартинкаПроблемыПослеСканированияУпаковки.Видимость  = Ложь;
	Элементы.ДекорацияПроблемыПослеСканированияУпаковки.Заголовок = 
		НСтр("ru = 'Отсканированная упаковка в данных документа не найдена.
		           |Для проверки содержимого упаковки отсканируйте штрихкод заново.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканировалиКодDataMatrixВместоУпаковкиУпаковки()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковки.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияУпаковки.Видимость    = Истина;
	Элементы.ДекорацияПроблемыПослеСканированияУпаковки.Заголовок  = 
		НСтр("ru = 'Отсканирован код ""DataMatrix"".
		           |Требуется отсканировать упаковку, в которой обнаружена вложенная упаковка.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканировалиКодМаркировкиВместоУпаковки()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковки.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияУпаковки.Видимость    = Истина;
	Элементы.ДекорацияПроблемыПослеСканированияПродукции.Заголовок  = 
		НСтр("ru = 'Отсканирован код маркировки.
		           |Требуется отсканировать упаковку, в которой обнаружена вложенная упаковка.'");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ДействияПриЗакрытии

&НаКлиенте
Процедура ПереместитьУпаковкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки)
	
	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия", "ПереместитьУпаковкуВДругуюУпаковку");
	СтруктураДействия.Вставить("ШтрихкодПеремещаемойУпаковки", Штрихкод);
	СтруктураДействия.Вставить("ШтрихкодУпаковкиНазначения",   ШтрихкодОтсканированнойУпаковки);
	
	СтруктураДействия.Вставить(
		"СтатусПроверки",
		?(СтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.НеЧислилась"),
			СтатусПроверки,
			ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.ВНаличии")));
	
	Закрыть(СтруктураДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьПродукциюВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки)
	
	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия", "ПереместитьПродукциюВДругуюУпаковку");
	СтруктураДействия.Вставить("ШтрихкодПеремещаемойПродукции", Штрихкод);
	СтруктураДействия.Вставить("ШтрихкодУпаковкиНазначения",    ШтрихкодОтсканированнойУпаковки);
	
	СтруктураДействия.Вставить(
		"СтатусПроверки",
		?(СтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.НеЧислилась"),
			СтатусПроверки,
			ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.ВНаличии")));
	
	Закрыть(СтруктураДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура ИзменитьКонтекстПроверки()
	
	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия", "ИзменитьКонтекстПроверки");
	
	Закрыть(СтруктураДействия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаПоискаПоШтрихкоду

&НаКлиенте
Процедура РучнойВводШтрихкодаЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт

	ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода)
	
	Если Не ОжидаетсяСканированиеУпаковки Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеШтрихкода = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РезультатРазбораКодаМаркировки = РазборКодаМаркировкиИССлужебныйКлиент.РазобратьКодМаркировки(ДанныеШтрихкода.Штрихкод, ВидМаркируемойПродукции);
	Если РезультатРазбораКодаМаркировки = Неопределено Тогда
		ШтрихкодОтсканированнойУпаковки = ДанныеШтрихкода.Штрихкод;
	Иначе
		ШтрихкодОтсканированнойУпаковки = РезультатРазбораКодаМаркировки.НормализованныйКодМаркировки;
	КонецЕсли;
	
	ЭтоУпаковкаДокумента   = УпаковкиДокумента.НайтиПоЗначению(ШтрихкодОтсканированнойУпаковки) <> Неопределено;
	ЭтоДобавленнаяУпаковка = ДобавленныеУпаковки.НайтиПоЗначению(ШтрихкодОтсканированнойУпаковки) <> Неопределено;
	МожноИзменитьКонтекст  = ДоступныеДляПроверкиУпаковки.НайтиПоЗначению(ШтрихкодОтсканированнойУпаковки) <> Неопределено;
	
	Если ТипУпаковкиНайденного = ПредопределенноеЗначение("Перечисление.ТипыУпаковок.МаркированныйТовар") Тогда
		
		ПереместитьПродукцию(ЭтоУпаковкаДокумента, ЭтоДобавленнаяУпаковка, РезультатРазбораКодаМаркировки, МожноИзменитьКонтекст);
	
	Иначе
		
		ПереместитьУпаковку(ЭтоУпаковкаДокумента, ЭтоДобавленнаяУпаковка, РезультатРазбораКодаМаркировки, МожноИзменитьКонтекст);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьПродукцию(ЭтоУпаковкаДокумента, ЭтоДобавленнаяУпаковка, ДанныеКодаМаркировки, МожноИзменитьКонтекст)
	
	Если ДанныеКодаМаркировки = Неопределено Тогда
		ШтрихкодОтсканированнойУпаковки = "";
	Иначе
		ШтрихкодОтсканированнойУпаковки = ДанныеКодаМаркировки.НормализованныйКодМаркировки;
	КонецЕсли;
	
	Если ЭтоУпаковкаДокумента Или ЭтоДобавленнаяУпаковка Тогда
		
		Если ШтрихкодУпаковкиГдеДолжноБыть = ШтрихкодОтсканированнойУпаковки Тогда
			
			Если МожноИзменитьКонтекст Тогда
			
				ИзменитьКонтекстПроверки();
				
			Иначе
				
				ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияПродукции();
				
			КонецЕсли;
			
		ИначеЕсли  ШтрихкодОтсканированнойУпаковки = Штрихкод Тогда
			
			ПоказатьПовторноОтсканировалиУпаковкуПродукции();
			
		Иначе
			
			Если РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены") Тогда
				
				Если МожноИзменитьКонтекст Тогда
					
					ПереместитьПродукциюВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки);
					
				Иначе
					
					ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияПродукции();
					
				КонецЕсли;
				
			ИначеЕсли НеСодержитсяВДанныхДокумента И ЭтоДобавленнаяУпаковка Тогда
				
				ПереместитьПродукциюВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки);
				
			ИначеЕсли НеСодержитсяВДанныхДокумента И ЭтоУпаковкаДокумента Тогда
				
				ПоказатьПереместитьВПродукциюБезУпаковки();
				
			Иначе
				
				ПоказатьОтложитьПродукцию(ЭтотОбъект);
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Если ДанныеКодаМаркировки = Неопределено Тогда
			
			ПоказатьОтсканированнаяУпаковкаПродукцииНеНайдена();
			
		ИначеЕсли ДанныеКодаМаркировки.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.PDF417") Тогда
			
			ПоказатьОтсканировалиКодМаркировкиВместоПродукции();
			
		ИначеЕсли  ДанныеКодаМаркировки.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.DataMatrix") Тогда
			
			ПоказатьОтсканировалиКодDataMatrixВместоУпаковкиПродукции();
			
		Иначе
			
			ПоказатьОтсканированнаяУпаковкаПродукцииНеНайдена();
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура ПереместитьУпаковку(ЭтоУпаковкаДокумента, ЭтоДобавленнаяУпаковка, ДанныеКодаМаркировки, МожноИзменитьКонтекст)
	
	Если ДанныеКодаМаркировки = Неопределено Тогда
		ШтрихкодОтсканированнойУпаковки = "";
	Иначе
		ШтрихкодОтсканированнойУпаковки = ДанныеКодаМаркировки.НормализованныйКодМаркировки;
	КонецЕсли;
	
	Если ЭтоУпаковкаДокумента Или ЭтоДобавленнаяУпаковка Тогда
		
		Если ШтрихкодУпаковкиГдеДолжноБыть = ШтрихкодОтсканированнойУпаковки Тогда
			
			Если МожноИзменитьКонтекст Тогда
				
				ИзменитьКонтекстПроверки();
				
			Иначе
				
				ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияУпаковки();
				
			КонецЕсли;
			
		ИначеЕсли ШтрихкодОтсканированнойУпаковки = Штрихкод Тогда
			
			ПоказатьПовторноОтсканировалиУпаковку();
			
		ИначеЕсли ЭтоДобавленнаяУпаковка Тогда
			
			Если НеСодержитсяВДанныхДокумента Тогда
				
				ПереместитьУпаковкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки);
			
			Иначе
				
				Если РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены") Тогда
					
					ПереместитьУпаковкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки);
					
				Иначе
					
					ПоказатьОтложитьУпаковку(ЭтотОбъект);
					
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли ЭтоУпаковкаДокумента Тогда
			
			Если РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены") Тогда
				
				Если МожноИзменитьКонтекст Тогда
					
					ПереместитьУпаковкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки);
					
				Иначе
					
					ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияУпаковки();
					
				КонецЕсли;
				
			Иначе
				
				ПоказатьОтложитьУпаковку(ЭтотОбъект);
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Если ДанныеКодаМаркировки = Неопределено Тогда
			
			ПоказатьОтсканированнаяУпаковкаУпаковкиНеНайдена();
			
		ИначеЕсли ДанныеКодаМаркировки.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.PDF417") Тогда
			
			ПоказатьОтсканировалиКодМаркировкиВместоУпаковки();
			
		ИначеЕсли  ДанныеКодаМаркировки.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.DataMatrix") Тогда
			
			ПоказатьОтсканировалиКодDataMatrixВместоУпаковкиУпаковки();
			
		Иначе
			
			ПоказатьОтсканированнаяУпаковкаУпаковкиНеНайдена();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Функция ТекстОтложите(Форма)
	
	Если Форма.СтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.Отложена") Тогда
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(Форма.ТипУпаковкиНайденного) Тогда
			
			ТекстУпаковка = НСтр("ru = 'Упаковка'");
			
		Иначе
			
			ТекстУпаковка = НСтр("ru = 'Продукция'");
			
		КонецЕсли;
		
		Возврат СтрШаблон(
			НСтр("ru = '%1 уже отложена и помечена стикером № ""%2"".'"),
			ТекстУпаковка,
			Формат(Форма.СледующийСтикерОтложено - 1, "ЧДЦ=; ЧГ=0"));
		
	Иначе
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(Форма.ТипУпаковкиНайденного) Тогда
			
			ТекстУпаковка = НСтр("ru = 'упаковку'");
			
		Иначе
			
			ТекстУпаковка = НСтр("ru = 'продукцию'");
			
		КонецЕсли;
		
		Возврат СтрШаблон(
			НСтр("ru = 'Пометьте найденную %1 стикером № ""%2"" и отложите в сторону.'"),
			ТекстУпаковка,
			Формат(Форма.СледующийСтикерОтложено, "ЧДЦ=; ЧГ=0"));
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОбработатьИПроверитьПереданныеПараметры()
	
	Штрихкод                = Параметры.Штрихкод;
	ШтрихкодНайден          = Параметры.ШтрихкодНайден;
	ВидМаркируемойПродукции = Параметры.ВидМаркируемойПродукции;
	
	ЭтоШтрихкодПродукции                 = Параметры.ЭтоШтрихкодПродукции;
	УпаковкаНеСодержитсяВДанныхДокумента = Параметры.УпаковкаНеСодержитсяВДанныхДокумента;
	РежимПроверки                        = Параметры.РежимПроверки;
	СтатусПроверки                       = Параметры.СтатусПроверки;

	ШтрихкодУпаковкиГдеДолжноБыть        = Параметры.ШтрихкодУпаковкиГдеДолжноБыть;
	НеСодержитсяВДанныхДокумента         = Параметры.НеСодержитсяВДанныхДокумента;
	
	ТипУпаковкиГдеДолжноНаходиться       = Параметры.ТипУпаковкиГдеДолжноНаходиться;
	ТипУпаковкиГдеНашли                  = Параметры.ТипУпаковкиГдеНашли;
	ТипУпаковкиНайденного                = Параметры.ТипУпаковкиНайденного;
	
	НомерСтикераОтложено                 = Параметры.НомерСтикераОтложено;
	СледующийСтикерОтложено              = Параметры.СледующийСтикерОтложено;
	
	ДобавленныеУпаковки                  = Параметры.ДобавленныеУпаковки;
	УпаковкиДокумента                    = Параметры.УпаковкиДокумента;
	ДоступныеДляПроверкиУпаковки         = Параметры.ДоступныеДляПроверкиУпаковки;
	
	РежимПодбораСуществующихУпаковок     = Параметры.РежимПодбораСуществующихУпаковок;
	ОбработкаДанныхТСД                   = Параметры.ОбработкаДанныхТСД;
	
КонецПроцедуры 

&НаСервере
Процедура СформироватьПредложенияДействий()
	
	Если Не ШтрихкодНайден Тогда
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаНеНайдено;
		
		Если ЭтоШтрихкодПродукции Тогда

			Элементы.СтраницыНеНайдено.ТекущаяСтраница = Элементы.СтраницаОтсканировалиМаркировкуНетНеизвестных;
			Элементы.ПереместитьВПродукциюБезУпаковкиНеНайдено.КнопкаПоУмолчанию = Истина;
			Элементы.ГруппаПереместитьВПродукциюБезУпаковкиНеНайдено.Видимость   = Истина;
			
		Иначе
			
			УстановитьДействиеОтсканировалиНеизвестнуюУпаковку();
			
		КонецЕсли;
		
	Иначе
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаНайдено;
		
		Если ТипУпаковкиНайденного = Перечисления.ТипыУпаковок.МаркированныйТовар Тогда
			
			Если ОбработкаДанныхТСД Тогда
				
				ПоказатьОтложитьПродукцию(ЭтотОбъект);
				
			Иначе
				
				ОжидаетсяСканированиеУпаковки = Истина;
				
			КонецЕсли;
			
			Элементы.СтраницыНайдено.ТекущаяСтраница = Элементы.СтраницаНайденоПродукция;
			
		Иначе
			
			Если ОбработкаДанныхТСД Тогда
				
				ПоказатьОтложитьУпаковку(ЭтотОбъект);
				
			Иначе
			
				ОжидаетсяСканированиеУпаковки = Истина;
				
			КонецЕсли;
			
			Элементы.СтраницыНайдено.ТекущаяСтраница = Элементы.СтраницаНайденоУпаковка;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДействиеОтсканировалиНеизвестнуюУпаковку()

	Если РежимПодбораСуществующихУпаковок Тогда
		ТекстВопроса  = НСтр("ru = 'Добавить новую пустую упаковку?'");
	Иначе
		ТекстВопроса = НСтр("ru = 'Упаковка не найдена в данных документа. Добавить в список проверяемого?'");
	КонецЕсли;
	
	Элементы.ДекорацияНеНайденоОтсканировалиУпаковку.Заголовок = ТекстВопроса;
	Элементы.СтраницыНеНайдено.ТекущаяСтраница = Элементы.СтраницаОтсканировалиУпаковку;

КонецПроцедуры 

&НаСервере
Процедура СформироватьИнформациюОРезультатахПоиска()

	ПредставлениеШтрихкода = ШтрихкодированиеОбщегоНазначенияИСКлиентСервер.ПредставлениеШтрихкода(Штрихкод);
	
	СтрокаШтрихкод = Новый ФорматированнаяСтрока(ПредставлениеШтрихкода, Новый Шрифт(,,Истина));
	
	Если ШтрихкодНайден Тогда
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(ТипУпаковкиНайденного) Тогда
			Префикс = НСтр("ru = 'Упаковка со штрихкодом'");
		Иначе
			Префикс = НСтр("ru = 'Продукция с кодом маркировки'");
		КонецЕсли;
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(ТипУпаковкиГдеДолжноНаходиться) Тогда
			Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(ТипУпаковкиГдеНашли) Тогда 
				Постфикс = НСтр("ru = 'найдена, но должна находиться в другой упаковке.'");
			Иначе
				Постфикс = НСтр("ru = 'найдена, но должна находиться в упаковке.'");
			КонецЕсли;
		Иначе
			Постфикс = НСтр("ru = 'найдена, но не должна находиться в упаковке.'");
		КонецЕсли;
		
		ТекстШтрихкодНеНайден = Новый ФорматированнаяСтрока(Префикс, " """, СтрокаШтрихкод, """ ", Постфикс);
		
	Иначе
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(ТипУпаковкиНайденного) Тогда
			Префикс = НСтр("ru = 'Упаковка со штрихкодом'");
			Постфикс = НСтр("ru = 'в данных документа не найдена.'");
		Иначе
			Префикс = НСтр("ru = 'Код маркировки'");
			Постфикс = НСтр("ru = 'в данных документа не найден.'");
		КонецЕсли;
		ТекстШтрихкодНеНайден = Новый ФорматированнаяСтрока(Префикс, " """, СтрокаШтрихкод, """ ", Постфикс);
		
	КонецЕсли;
	
	Элементы.ДекорацияИнформацияОРезультатахПоиска.Заголовок = ТекстШтрихкодНеНайден;

КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовокФормы()
	
	Если ШтрихкодНайден Тогда
		
		Заголовок = НСтр("ru = 'Код маркировки найден'");
		
	Иначе
		
		Заголовок = НСтр("ru = 'Код маркировки не найден'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти