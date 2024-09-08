﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Склад = Параметры.Склад;
	ЗаполнитьТаблицуКОформлениюПередач();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ОформитьПередачу(Команда)
	
	СформироватьВыделенныеДокументыПередачи();
	ЗаполнитьТаблицуКОформлениюПередач();
	
КонецПроцедуры

&НаКлиенте
Процедура РаспечататьВсе(Команда)
	
	ВывестиВсеПечатныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура РаспечататьВыделенные(Команда)
	
	ВывестиВыделенныеПечатныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьВсеПередачи(Команда)
	
	СформироватьВсеДокументыПередачи();
	ЗаполнитьТаблицуКОформлениюПередач();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьИРаспечататьВсе(Команда)
	
	СформироватьВсеДокументыПередачи();
	ВывестиВсеПечатныеФормы();
	ЗаполнитьТаблицуКОформлениюПередач();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьИРаспечататьВыделенные(Команда)
	
	СформироватьВыделенныеДокументыПередачи();
	ВывестиВыделенныеПечатныеФормы();
	ЗаполнитьТаблицуКОформлениюПередач();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуКОформлениюПередач()
	
	Запрос = Новый Запрос;
	Запрос.Текст = Обработки.ПанельАдминистрированияУчетПрослеживаемыхТоваров.СформироватьТекстЗапросаТаблицаКОформлениюПередач();
	
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("ХОПередачаНаКомиссию", Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию);
	
	РезультатЗапроса = Запрос.Выполнить();
	КОформлениюПередач.Загрузить(РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура СоздатьДокументРеализацияТоваров(Организация, Комиссионер, Соглашение, ДокументВозврат)
	
	ДокументРеализация = Документы.РеализацияТоваровУслуг.СоздатьДокумент();
	ДокументРеализация.Дата                     = ТекущаяДатаСеанса();
	ДокументРеализация.ХозяйственнаяОперация    = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию;
	ДокументРеализация.Организация              = Организация;
	ДокументРеализация.Партнер                  = Комиссионер;
	ДокументРеализация.Соглашение               = Соглашение;
	ДокументРеализация.Склад                    = Склад;
	ДокументРеализация.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.РеализацияТоваровУслуг;
	ДокументРеализация.СпособДоставки           = Перечисления.СпособыДоставки.Самовывоз;
	ДокументРеализация.ОснованиеДата            = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументВозврат, "Дата");
	ДокументРеализация.ОснованиеНомер           = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументВозврат, "Номер");
	ДокументРеализация.Подразделение            = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументВозврат, "Подразделение");
	ДокументРеализация.Статус                   = Перечисления.СтатусыРеализацийТоваровУслуг.Отгружено;
	
	ДокументРеализация.ЗаполнитьУсловияПродажПоСоглашению();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВозвратТоваровОтКлиентаТовары.Ссылка КАК Ссылка,
		|	ВозвратТоваровОтКлиентаТовары.НомерСтроки КАК НомерСтроки,
		|	ВозвратТоваровОтКлиентаТовары.Номенклатура КАК Номенклатура,
		|	ВозвратТоваровОтКлиентаТовары.Характеристика КАК Характеристика,
		|	ВозвратТоваровОтКлиентаТовары.Упаковка КАК Упаковка,
		|	ВозвратТоваровОтКлиентаТовары.КоличествоУпаковок КАК КоличествоУпаковок,
		|	ВозвратТоваровОтКлиентаТовары.Количество КАК Количество,
		|	ВозвратТоваровОтКлиентаТовары.КоличествоПоРНПТ КАК КоличествоПоРНПТ,
		|	ВозвратТоваровОтКлиентаТовары.Цена КАК Цена,
		|	ВозвратТоваровОтКлиентаТовары.Сумма КАК Сумма,
		|	ВозвратТоваровОтКлиентаТовары.СтавкаНДС КАК СтавкаНДС,
		|	ВозвратТоваровОтКлиентаТовары.СуммаНДС КАК СуммаНДС,
		|	ВозвратТоваровОтКлиентаТовары.СуммаСНДС КАК СуммаСНДС,
		|	ВозвратТоваровОтКлиентаТовары.СтатусУказанияСерий КАК СтатусУказанияСерий,
		|	ВозвратТоваровОтКлиентаТовары.Серия КАК Серия,
		|	ВозвратТоваровОтКлиентаТовары.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
		|	ВозвратТоваровОтКлиентаТовары.НоменклатураНабора КАК НоменклатураНабора,
		|	ВозвратТоваровОтКлиентаТовары.ХарактеристикаНабора КАК ХарактеристикаНабора,
		|	ВозвратТоваровОтКлиентаТовары.АналитикаУчетаНаборов КАК АналитикаУчетаНаборов,
		|	ВозвратТоваровОтКлиентаТовары.ВидЦеныСебестоимости КАК ВидЦеныСебестоимости,
		|	ВозвратТоваровОтКлиентаТовары.Назначение КАК Назначение,
		|	ВозвратТоваровОтКлиентаТовары.Ссылка.Склад КАК Склад
		|ИЗ
		|	Документ.ВозвратТоваровОтКлиента.Товары КАК ВозвратТоваровОтКлиентаТовары
		|ГДЕ
		|	ВозвратТоваровОтКлиентаТовары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументВозврат);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокаТовары =ДокументРеализация.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТовары, ВыборкаДетальныеЗаписи);
		
		// пересчет цен и сумм в зависимости от включения НДС в цену
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(ДокументРеализация);
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
		
		Если ДокументРеализация.ЦенаВключаетНДС Тогда
			СтруктураДействий.Вставить("ПересчитатьСумму");
			СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
		КонецЕсли;
		
		Для Каждого Строка Из ДокументРеализация.Товары Цикл
			ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(Строка, СтруктураДействий, Неопределено);
		КонецЦикла;
		
		// сумма документа
		ДокументРеализация.СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(ДокументРеализация.Товары, ДокументРеализация.ЦенаВключаетНДС);
		
	КонецЦикла;
	
	ПараметрыЗаполнения = Документы.РеализацияТоваровУслуг.ПараметрыЗаполненияНалогообложенияНДСПродажи(ДокументРеализация);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(Неопределено, ПараметрыЗаполнения);
	
	Если ДокументРеализация.ПроверитьЗаполнение() Тогда
		ДокументРеализация.Записать(РежимЗаписиДокумента.Проведение);
	Иначе
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Документ не проведен: %1.'", ДокументРеализация));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
		ДокументРеализация.Записать(РежимЗаписиДокумента.Запись);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьКоллекциюМакетовВозвраты(МассивДокументов)
	
	ПараметрыПечати = Новый Структура();
	ПараметрыПечати.Вставить("ДополнитьКомплектВнешнимиПечатнымиФормами", ЛОЖЬ);
	
	ВременнаяКоллекцияДляОднойПечатнойФормы = УправлениеПечатью.ПодготовитьКоллекциюПечатныхФорм("ВозвратОтКлиента");
	
	ОбъектыПечати = Новый СписокЗначений;
	
	ПараметрыВывода = УправлениеПечатью.ПодготовитьСтруктуруПараметровВывода();
	
	Документы.ВозвратТоваровОтКлиента.Печать(МассивДокументов, ПараметрыПечати, ВременнаяКоллекцияДляОднойПечатнойФормы, ОбъектыПечати, ПараметрыВывода);
	
	Возврат ТаблицуВМассивМакетов(ВременнаяКоллекцияДляОднойПечатнойФормы);
	
КонецФункции

&НаСервере
Функция СформироватьКоллекциюМакетовРеализация(МассивДокументов)
	
	ПараметрыПечати = Новый Структура();
	ПараметрыПечати.Вставить("ДополнитьКомплектВнешнимиПечатнымиФормами", ЛОЖЬ);
	
	ВременнаяКоллекцияДляОднойПечатнойФормы = УправлениеПечатью.ПодготовитьКоллекциюПечатныхФорм("Накладная");
	
	ОбъектыПечати = Новый СписокЗначений;
	
	ПараметрыВывода = УправлениеПечатью.ПодготовитьСтруктуруПараметровВывода();
	
	Документы.РеализацияТоваровУслуг.Печать(МассивДокументов, ПараметрыПечати, ВременнаяКоллекцияДляОднойПечатнойФормы, ОбъектыПечати, ПараметрыВывода);
	
	Возврат ТаблицуВМассивМакетов(ВременнаяКоллекцияДляОднойПечатнойФормы);
	
КонецФункции

&НаСервереБезКонтекста
Функция МассивРеализаций(МассивРеализаций, Организация, Комиссионер, Соглашение, Склад)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РеализацияТоваровУслуг.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		|ГДЕ
		|	РеализацияТоваровУслуг.Проведен
		|	И РеализацияТоваровУслуг.Организация = &Организация
		|	И РеализацияТоваровУслуг.Партнер = &Партнер
		|	И РеализацияТоваровУслуг.Соглашение = &Соглашение
		|	И РеализацияТоваровУслуг.Склад = &Склад";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Партнер", Комиссионер);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МассивРеализаций.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
	
	Возврат МассивРеализаций;
	
КонецФункции

&НаКлиенте
Процедура ВывестиВсеПечатныеФормы() 
	
	МассивВозвратов  = Новый Массив;
	МассивРеализаций = Новый Массив;
	
	Для Каждого Строка Из КОформлениюПередач Цикл
		
		МассивВозвратов.Добавить(Строка.Возврат);
		
		МассивРеализаций(МассивРеализаций, Строка.Организация, Строка.Комиссионер, Строка.Соглашение, Склад);
		
	КонецЦикла;
	
	КоллекцияВозвратов  = СформироватьКоллекциюМакетовВозвраты(МассивВозвратов);
	КоллекцияРеализаций = СформироватьКоллекциюМакетовРеализация(МассивРеализаций);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(КоллекцияВозвратов, КоллекцияРеализаций);
	
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияВозвратов);
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиВыделенныеПечатныеФормы()
	
	Если Элементы.КОформлениюПередач.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивВозвратов  = Новый Массив;
	МассивРеализаций = Новый Массив;
	
	Для Каждого СтрокаИД Из Элементы.КОформлениюПередач.ВыделенныеСтроки Цикл
		
		МассивВозвратов.Добавить(Элементы.КОформлениюПередач.ДанныеСтроки(СтрокаИД).Возврат);
		
		Организация = Элементы.КОформлениюПередач.ДанныеСтроки(СтрокаИД).Организация;
		Комиссионер = Элементы.КОформлениюПередач.ДанныеСтроки(СтрокаИД).Комиссионер;
		Соглашение  = Элементы.КОформлениюПередач.ДанныеСтроки(СтрокаИД).Соглашение;
		
		МассивРеализаций(МассивРеализаций, Организация, Комиссионер, Соглашение, Склад);
		
	КонецЦикла;
	
	КоллекцияВозвратов  = СформироватьКоллекциюМакетовВозвраты(МассивВозвратов);
	КоллекцияРеализаций = СформироватьКоллекциюМакетовРеализация(МассивРеализаций);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(КоллекцияВозвратов, КоллекцияРеализаций);
	
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияВозвратов);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьВсеДокументыПередачи()
	
	Для Каждого Строка Из КОформлениюПередач Цикл
		
		Если Строка.Передача Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Для документа:  %1 передача уже оформлена.'"), Строка.Возврат);
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			
			Продолжить;
			
		КонецЕсли;
		
		Попытка
			СоздатьДокументРеализацияТоваров(Строка.Организация, Строка.Комиссионер, Строка.Соглашение, Строка.Возврат);
		Исключение
			ТекстСообщения = СтрШаблон(
				НСтр("ru='Не удалось создать документ передачи на основании возврата %1 по причине: %2.'"), 
				Строка.Возврат,
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьВыделенныеДокументыПередачи()
	
	Если Элементы.КОформлениюПередач.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаИД Из Элементы.КОформлениюПередач.ВыделенныеСтроки Цикл
		
		Если Элементы.КОформлениюПередач.ДанныеСтроки(СтрокаИД).Передача Тогда
			
			ТекстСообщения = НСтр("ru = 'Передача уже оформлена.'");
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			
			Продолжить;
			
		КонецЕсли;
		
		Организация      = Элементы.КОформлениюПередач.ДанныеСтроки(СтрокаИД).Организация;
		Комиссионер      = Элементы.КОформлениюПередач.ДанныеСтроки(СтрокаИД).Комиссионер;
		Соглашение       = Элементы.КОформлениюПередач.ДанныеСтроки(СтрокаИД).Соглашение;
		ДокументВозврат  = Элементы.КОформлениюПередач.ДанныеСтроки(СтрокаИД).Возврат;
		
		Попытка
			СоздатьДокументРеализацияТоваров(Организация, Комиссионер, Соглашение, ДокументВозврат);
		Исключение
			ТекстСообщения = СтрШаблон(
				НСтр("ru='Не удалось создать документ передачи на основании возврата %1 по причине: %2.'"), 
				ДокументВозврат,
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ТаблицуВМассивМакетов(ВременнаяКоллекцияДляОднойПечатнойФормы)
	
	Массив = Новый Массив;
	
	Для Каждого Строка Из ВременнаяКоллекцияДляОднойПечатнойФормы Цикл
		
		Структура = Новый Структура;
		Для Каждого Колонка Из ВременнаяКоллекцияДляОднойПечатнойФормы.Колонки Цикл
			
			Структура.Вставить(Колонка.Имя, Строка[Колонка.Имя]);
			
		КонецЦикла;
		
		Массив.Добавить(Структура);
		
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти