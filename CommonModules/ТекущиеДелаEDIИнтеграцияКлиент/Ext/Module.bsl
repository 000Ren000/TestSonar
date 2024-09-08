﻿#Область СлужебныйПрограммныйИнтерфейс

Процедура ОткрытьФормуЖурналаДокументов(ПараметрыОткрытия) Экспорт
	
	ИмяФормы = "Документы" + ПараметрыОткрытия.ВидЖурнала;
	
	СтруктураБыстрогоОтбора = Новый Структура;
	СтруктураБыстрогоОтбора.Вставить("Менеджер",                    ПараметрыОткрытия.Менеджер);
	СтруктураБыстрогоОтбора.Вставить("Организация",                 ПараметрыОткрытия.Организация);
	СтруктураБыстрогоОтбора.Вставить("ВыбранныеСтатусы",            ПараметрыОткрытия.ВыбранныеСтатусы);
	СтруктураБыстрогоОтбора.Вставить("ОтборПоСтатусамОтображается", Истина);
	Если ЗначениеЗаполнено(ПараметрыОткрытия.СтатусСоответствия) Тогда
		СтруктураБыстрогоОтбора.Вставить("СтатусСоответствия", ПараметрыОткрытия.СтатусСоответствия);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Обработка.СервисEDI.Форма." + ИмяФормы + ".Открыть");
	
	ОткрытьФорму("Обработка.СервисEDI.Форма." + ИмяФормы, ПараметрыФормы, ,,,,, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

Процедура ОбработатьСобытиеТекущихДелЖурналДокументов(Форма, НавигационнаяСсылкаФорматированнойСтроки) Экспорт

	Префикс = Лев(НавигационнаяСсылкаФорматированнойСтроки, 7);
	СтатусыСтрокой = Прав(НавигационнаяСсылкаФорматированнойСтроки, СтрДлина(НавигационнаяСсылкаФорматированнойСтроки) - 7);
	
	Если СтатусыСтрокой = "ВРаботе" Тогда
		МассивСтатусов = ДокументыEDIКлиентСервер.МассивСтатусовВРаботе();
	ИначеЕсли СтатусыСтрокой = "ОтклоненияПриВыполнении" Тогда
		МассивСтатусов = ДокументыEDIКлиентСервер.МассивСтатусовОтклоненияПриВыполнении();
	ИначеЕсли СтатусыСтрокой = "Архив" Тогда
		МассивСтатусов = ДокументыEDIКлиентСервер.МассивСтатусовАрхив();
	Иначе
		МассивСтатусов = Новый Массив;
		МассивСтатусов.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаказаEDI." + СтатусыСтрокой));
	КонецЕсли;
	
	Если Префикс = "Закупки" Тогда
		ТипыДокументов = Форма.ДоступныеДокументыЗакупки.ВыгрузитьЗначения();
	Иначе
		ТипыДокументов = Форма.ДоступныеДокументыПродажи.ВыгрузитьЗначения();
	КонецЕсли;
	
	ПараметрыОткрытияЖурналаДокументов = ПараметрыОткрытияЖурналаДокументов();
	ПараметрыОткрытияЖурналаДокументов.ИдентификаторыДокументов = ТипыДокументов;
	ПараметрыОткрытияЖурналаДокументов.ВыбранныеСтатусы         = МассивСтатусов;
	ПараметрыОткрытияЖурналаДокументов.Менеджер                 = Форма.Менеджер;
	ПараметрыОткрытияЖурналаДокументов.ВидЖурнала               = Префикс;
	
	ОткрытьФормуЖурналаДокументов(ПараметрыОткрытияЖурналаДокументов);
	
КонецПроцедуры

Процедура ОбработатьСобытиеТекущихДелЛентаСобытий(Форма, НавигационнаяСсылкаФорматированнойСтроки) Экспорт
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ИмяКоманды", НавигационнаяСсылкаФорматированнойСтроки);
	
	НайденныеСтроки = Форма.КомандыПоследнихСобытий.НайтиСтроки(ПараметрыОтбора);
	
	Если НайденныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПериодСобытий = Новый СтандартныйПериод;
	ПериодСобытий.ДатаНачала    = НачалоДня(НайденныеСтроки[0].Дата);
	ПериодСобытий.ДатаОкончания = КонецДня(НайденныеСтроки[0].Дата);
	
	Префикс = Сред(НавигационнаяСсылкаФорматированнойСтроки, 8, 7);
	Если Префикс = "Закупки" Тогда
		КатегорияДокумента = ПредопределенноеЗначение("Перечисление.КатегорииДокументовEDI.Закупка");
	ИначеЕсли Префикс = "Продажи" Тогда
		КатегорияДокумента = ПредопределенноеЗначение("Перечисление.КатегорииДокументовEDI.Продажа");
	Иначе
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытияФормы = РаботаСЛентойСобытийEDIКлиент.НовыйПараметрыОткрытияФормыЛентыСобытий();
	ПараметрыОткрытияФормы.Менеджер            = Форма.Менеджер;
	ПараметрыОткрытияФормы.КатегорияДокументов = КатегорияДокумента;
	ПараметрыОткрытияФормы.Период              = ПериодСобытий;
	
	РаботаСЛентойСобытийEDIКлиент.ОткрытьФормуЛентыСобытий(ПараметрыОткрытияФормы);
	
КонецПроцедуры

Процедура ОбработатьСобытиеНастройкиСправочники(Форма, НавигационнаяСсылкаФорматированнойСтроки) Экспорт
	
	СтандартнаяОбработка = Истина;
	
	СервисEDIКлиентПереопределяемый.ОбработатьСобытиеТекущихДелНастройкиСправочники(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "Настройки" Тогда
		
		ОткрытьФорму("Обработка.СервисEDI.Форма.НастройкиПроцессов");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьСобытиеКонтроляПлановыхДатВыполнения(Форма, НавигационнаяСсылкаФорматированнойСтроки) Экспорт
	
	Если СтрНайти(НавигационнаяСсылкаФорматированнойСтроки, "КонтрольПоступлений") > 0 Тогда
		Префикс          = "КонтрольПоступлений";
		ПостфиксИмяФормы = "Закупки";
	ИначеЕсли СтрНайти(НавигационнаяСсылкаФорматированнойСтроки, "КонтрольОтгрузок") > 0 Тогда
		Префикс          = "КонтрольОтгрузок";
		ПостфиксИмяФормы = "Продажи";
	Иначе
		Возврат;
	КонецЕсли;
	
	ПериодКонтроляСтрокой = Прав(НавигационнаяСсылкаФорматированнойСтроки, СтрДлина(НавигационнаяСсылкаФорматированнойСтроки) - СтрДлина(Префикс));
	
	ПлановаяДатаПериод = Новый СтандартныйПериод;
	ПлановаяДатаОтбор  = ПериодКонтроляСтрокой;
	
	Если ПериодКонтроляСтрокой = "Просрочено" Тогда
		
		ПлановаяДатаПериод.ДатаОкончания = НачалоДня(Форма.ТекущаяДата);
		
	ИначеЕсли ПериодКонтроляСтрокой = "Сегодня" Тогда
		
		ПлановаяДатаПериод.ДатаНачала    = НачалоДня(Форма.ТекущаяДата);
		ПлановаяДатаПериод.ДатаОкончания = КонецДня(Форма.ТекущаяДата);
		
	ИначеЕсли ПериодКонтроляСтрокой = "Завтра" Тогда
		
		ПлановаяДатаПериод.ДатаНачала    = НачалоДня(Форма.ТекущаяДата) + 86400;
		ПлановаяДатаПериод.ДатаОкончания = КонецДня(Форма.ТекущаяДата)  + 86400;
		
	ИначеЕсли ПериодКонтроляСтрокой = "ТриДня" Тогда
		
		ПлановаяДатаПериод.ДатаНачала    = НачалоДня(Форма.ТекущаяДата);
		ПлановаяДатаПериод.ДатаОкончания = КонецДня(Форма.ТекущаяДата) + 86400 * 2;
		
	ИначеЕсли ПериодКонтроляСтрокой = "Неделя" Тогда
		
		ПлановаяДатаПериод.ДатаНачала    = НачалоДня(Форма.ТекущаяДата);
		ПлановаяДатаПериод.ДатаОкончания = КонецДня(Форма.ТекущаяДата) + 86400 * 6;
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	СтруктураБыстрогоОтбора = Новый Структура;
	СтруктураБыстрогоОтбора.Вставить("ПлановаяДатаПериод",          ПлановаяДатаПериод);
	СтруктураБыстрогоОтбора.Вставить("ПлановаяДатаОтбор",           ПлановаяДатаОтбор);
	СтруктураБыстрогоОтбора.Вставить("ОтборПоСтатусамОтображается", Истина);
	СтруктураБыстрогоОтбора.Вставить("ВыбранныеСтатусы",            ДокументыEDIКлиентСервер.МассивСтатусовВыполняется());
	СтруктураБыстрогоОтбора.Вставить("Менеджер",                    Форма.Менеджер);
	
	ИмяФормы = "Документы" + ПостфиксИмяФормы;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОткрытьФорму("Обработка.СервисEDI.Форма." + ИмяФормы, ПараметрыФормы, ,,,,, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

Процедура ОбработатьСобытиеДоступныеДляОтправки(Форма, НавигационнаяСсылкаФорматированнойСтроки) Экспорт
	
	СтруктураБыстрогоОтбора = Новый Структура;
	СтруктураБыстрогоОтбора.Вставить("Менеджер", Форма.Менеджер);
	СтруктураБыстрогоОтбора.Вставить("ПоказатьСкрытые", Ложь);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОткрытьФорму("Обработка.СервисEDI.Форма.ДокументыКОтправке", ПараметрыОткрытия,, Форма.УникальныйИдентификатор,
	             ,,,РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

Процедура СоздатьНовыйЗаказПоставщику() Экспорт
	
	ОткрытьФорму(ТекущиеДелаEDIКлиентПовтИсп.ИмяФормыЗаказПоставщику());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыОткрытияЖурналаДокументов() Экспорт
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ИдентификаторыДокументов",       Неопределено);
	ПараметрыОткрытия.Вставить("Менеджер",                       Неопределено);
	ПараметрыОткрытия.Вставить("Организация",                    Неопределено);
	ПараметрыОткрытия.Вставить("ВыбранныеСтатусы",               Неопределено);
	ПараметрыОткрытия.Вставить("СтатусСоответствия",             Неопределено);
	ПараметрыОткрытия.Вставить("ТипыДокументов",                 Неопределено);
	ПараметрыОткрытия.Вставить("ОтборПоСтатусамОтображается",    Истина);
	ПараметрыОткрытия.Вставить("ВидЖурнала",                     "");
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

#КонецОбласти