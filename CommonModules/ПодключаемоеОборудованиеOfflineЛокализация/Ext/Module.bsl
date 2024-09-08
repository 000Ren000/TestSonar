﻿////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции, используемые в модуле ПодключаемоеОборудованиеOffline
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Процедура ДобавитьВТекстЗапросаИдентификациюАкцизныхМарок(Запрос, ТекстЗапроса, ЗагрузкаАкцизныхМарок, КлючиЕГАИС, ДобавитьРазделитель = Истина) Экспорт

	//++ Локализация	
	ОрганизацияЕГАИС = ИнтеграцияЕГАИСУТ.ОрганизацияЕГАИСПоОрганизацииИСкладу(КлючиЕГАИС.Организация, КлючиЕГАИС.Склад);
	ЗагрузкаАкцизныхМарок = ЗначениеЗаполнено(ОрганизацияЕГАИС);
	
	Если ЗагрузкаАкцизныхМарок Тогда
		Если ДобавитьРазделитель = Истина Тогда
			ТекстЗапроса = ТекстЗапроса + ОбщегоНазначения.РазделительПакетаЗапросов();
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса + "ВЫБРАТЬ
		|	Товары.Код                      КАК Код,
		|	ВЫРАЗИТЬ(Товары.ШтрихкодАлкогольнойМарки КАК Строка(200)) КАК ШтрихкодАлкогольнойМарки,
		|	ВЫРАЗИТЬ(Товары.УникальныйИдентификатор КАК Строка(36))КАК УникальныйИдентификатор,
		|	ВЫРАЗИТЬ(Товары.НомерСмены КАК Строка(50)) КАК НомерСмены,
		|	ВЫРАЗИТЬ(Товары.ДатаЧека КАК Дата) КАК ДатаЧека		
		|ПОМЕСТИТЬ ВтТаблицаШтрихкодов
		|ИЗ
		|	&ТаблицаШтрихкодов КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.Код                      						КАК Код,
		|	ЕСТЬNULL(ШтрихкодыУпаковокТоваров.Ссылка, НЕОПРЕДЕЛЕНО) КАК АкцизнаяМарка,
		|	Товары.ШтрихкодАлкогольнойМарки 						КАК ШтрихкодАлкогольнойМарки,
		|	Товары.УникальныйИдентификатор  						КАК УникальныйИдентификатор,
		|	Товары.НомерСмены										КАК НомерСмены,
		|	Товары.ДатаЧека											КАК ДатаЧека		
		|ПОМЕСТИТЬ ВтТоварыСАкцизнымиМарками
		|ИЗ
		|	ВтТаблицаШтрихкодов КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ШтрихкодыУпаковокТоваров КАК ШтрихкодыУпаковокТоваров
		|		ПО Товары.ШтрихкодАлкогольнойМарки = ШтрихкодыУпаковокТоваров.ЗначениеШтрихкода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(КодыТоваровПодключаемогоОборудованияOffline.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка))                 КАК Номенклатура,
		|	ЕСТЬNULL(КодыТоваровПодключаемогоОборудованияOffline.Характеристика, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)) КАК Характеристика,
		|	Товары.АкцизнаяМарка						                                                                                       КАК АкцизнаяМарка,
		|	АкцизныеМаркиЕГАИС.Справка2                                                                                                        КАК Справка2,
		|	Товары.ШтрихкодАлкогольнойМарки                                                                                                    КАК ШтрихкодАлкогольнойМарки,
		|	Товары.УникальныйИдентификатор                                                                    	КАК УникальныйИдентификатор,
		|	Товары.НомерСмены                                                                    				КАК НомерСмены,
		|	Товары.ДатаЧека                                                                    					КАК ДатаЧека,
		|	ВЫБОР КОГДА Товары.АкцизнаяМарка = НЕОПРЕДЕЛЕНО ТОГДА ЛОЖЬ ИНАЧЕ ИСТИНА КОНЕЦ						КАК АкцизнаяМаркаНайдена,
		|	ВЫБОР КОГДА СправочникНоменклатура.ОсобенностьУчета = ЗНАЧЕНИЕ(Перечисление.ОсобенностиУчетаНоменклатуры.Пиво)
		|	И НЕ ОписаниеНоменклатурыИС.Номенклатура ЕСТЬ NULL ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ 					КАК ЭтоРазливноеПиво,
		|	ВЫБОР КОГДА НЕ ВскрытыеПотребительскиеУпаковкиИС.КодМаркировки ЕСТЬ NULL ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ 	КАК КегаНаОборудованииРозлива
		|ИЗ
		|	ВтТоварыСАкцизнымиМарками КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ПО Товары.Код = КодыТоваровПодключаемогоОборудованияOffline.Код
		|			И КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = &ПравилоОбмена
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АкцизныеМаркиЕГАИС КАК АкцизныеМаркиЕГАИС
		|		ПО Товары.АкцизнаяМарка = АкцизныеМаркиЕГАИС.АкцизнаяМарка
		|			И АкцизныеМаркиЕГАИС.ОрганизацияЕГАИС = &ОрганизацияЕГАИС
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
		|		ПО (КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = СправочникНоменклатура.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВскрытыеПотребительскиеУпаковкиИС КАК ВскрытыеПотребительскиеУпаковкиИС
		|		ПО (Товары.АкцизнаяМарка = ВскрытыеПотребительскиеУпаковкиИС.КодМаркировки)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОписаниеНоменклатурыИС КАК ОписаниеНоменклатурыИС
		|		ПО (СправочникНоменклатура.Ссылка = ОписаниеНоменклатурыИС.Номенклатура)
		|
		|УПОРЯДОЧИТЬ ПО
		|	АкцизнаяМарка,
		|	ШтрихкодАлкогольнойМарки,
		|	Номенклатура,
		|	Характеристика
		|";
		Запрос.УстановитьПараметр("ОрганизацияЕГАИС", ОрганизацияЕГАИС);

	Конецесли;
	//-- Локализация
	Возврат;
	
КонецПроцедуры

Процедура ЗаполнитьТабличнуюЧастьАкцизныеМарки(ПараметрыКассовойСмены, ОтчетОРозничныхПродажахОбъект, ТаблицаАкцизныеМарки, ОрганизацияЕГАИС) Экспорт
	
	//++ Локализация
	ОтчетОРозничныхПродажахОбъект.ОрганизацияЕГАИС   = ОрганизацияЕГАИС;
	НомерКассовойСменыДляПоиска = Лев(ПараметрыКассовойСмены.НомерСмены + "                                                   ", 50);
	УникальныйИдентификаторДляПоиска = Лев(ПараметрыКассовойСмены.УникальныйИдентификатор + "                                    ", 36);
	ОтборПоТаблицеАкцизныхМарок = Новый Структура("НомерСмены,УникальныйИдентификатор", НомерКассовойСменыДляПоиска, УникальныйИдентификаторДляПоиска);
	Для Каждого СтрокаАкциз Из ТаблицаАкцизныеМарки.НайтиСтроки(ОтборПоТаблицеАкцизныхМарок) Цикл
		
		Если ЗначениеЗаполнено(СтрокаАкциз.ШтрихкодАлкогольнойМарки) Тогда
			АкцизнаяМарка = СтрокаАкциз.АкцизнаяМарка;
			
			Если НЕ ЗначениеЗаполнено(АкцизнаяМарка) Тогда
				АкцизнаяМарка = ШтрихкодированиеЕГАИС.СгенерироватьАкцизнуюМарку(
					СтрокаАкциз.ШтрихкодАлкогольнойМарки,
					СтрокаАкциз.Номенклатура,
					СтрокаАкциз.Характеристика);
			КонецЕсли;
			НоваяСтрока = ОтчетОРозничныхПродажахОбъект.АкцизныеМарки.Добавить();
			НоваяСтрока.АкцизнаяМарка = АкцизнаяМарка;
			НоваяСтрока.Справка2 = СтрокаАкциз.Справка2;
			
		КонецЕсли;
		
	КонецЦикла;
	//-- Локализация
	Возврат;
	
КонецПроцедуры

//++ Локализация

// Заполняет статусы акцизных марок
// 
// Параметры:
// 	ДокументОбъект - ДокументОбъект.ОтчетОРозничныхПродажах                 - заполненный документ
// 	ОрганизацияЕГАИС - Булево, СправочникСсылка.КлассификаторОрганизацийЕГАИС - организация для которой загружен отчет
Процедура ЗаполнитьСтатусыПоТабличнойЧастиАкцизныеМарки(ДокументОбъект, ОрганизацияЕГАИС) Экспорт
	
	Если (ОрганизацияЕГАИС = Ложь) Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.АкцизныеМаркиЕГАИС.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОрганизацияЕГАИС.Установить(ОрганизацияЕГАИС);
	
	Для каждого СтрокаАкциз Из ДокументОбъект.АкцизныеМарки Цикл
		
		НаборЗаписей.Отбор.АкцизнаяМарка.Установить(СтрокаАкциз.АкцизнаяМарка);
		
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Количество() = 1 Тогда
			НаборЗаписей[0].Статус = Перечисления.СтатусыАкцизныхМарок.Реализована;
			НаборЗаписей.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

//-- Локализация

Процедура ЗаписатьОшибкуВЖурналРегистрации(КраткоеПредставлениеОшибки, ПредставлениеОшибки, СтандартнаяОбработка) Экспорт
	
	//++ Локализация
	СтандартнаяОбработка = Ложь;
	ТекстОшибки = НСтр("ru = 'При записи акцизных марок произошла ошибка:
		|%1'");
	ОбщегоНазначения.СообщитьПользователю(
		СтрШаблон(ТекстОшибки, КраткоеПредставлениеОшибки));
	ОбщегоНазначенияЕГАИСВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
		СтрШаблон(ТекстОшибки, ПредставлениеОшибки));
	//-- Локализация
	Возврат;
	
КонецПроцедуры
#КонецОбласти
