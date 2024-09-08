﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьОтчет(ТабличныйДокумент, ОтборДоговор, ОтборДокументы, ДанныеОтчета, ЕстьДанныеДляОтображения) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Очистить();
	
	Макет = ПолучитьМакет("Макет");
	
	ОбластьШапкаДвеКолонки = Макет.ПолучитьОбласть("ОбластьШапкаДвеКолонки");
	ОбластьШапкаОднаКолонка = Макет.ПолучитьОбласть("ОбластьШапкаОднаКолонка");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ОбластьШапкаТаблицы");
	ОбластьСтрока = Макет.ПолучитьОбласть("ОбластьСтрока");
	ОбластьПодвал = Макет.ПолучитьОбласть("ОбластьПодвал");
	
	ТаблицаДанныхДисконтирования = ПолучитьДанныеДисконтирования(ОтборДоговор, ОтборДокументы, ДанныеОтчета);
	
	ТаблицаГруппировок = ТаблицаДанныхДисконтирования.Скопировать( , "РасчетныйДокумент, ОбъектРасчетов, Организация, Долг, ДолгБезНДС, НачисленныеПроценты, ПриведеннаяСтоимость, СуммаАванса");
	ТаблицаГруппировок.Свернуть("РасчетныйДокумент, ОбъектРасчетов, Организация", "Долг, ДолгБезНДС, НачисленныеПроценты, ПриведеннаяСтоимость, СуммаАванса");
	
	ТаблицаДанныхДисконтирования.Индексы.Добавить("РасчетныйДокумент, ОбъектРасчетов");
	
	Отбор = Новый Структура("РасчетныйДокумент, ОбъектРасчетов");
	
	Для Каждого СтрокаГруппировки Из ТаблицаГруппировок Цикл
		
		ЗаполнитьЗначенияСвойств(Отбор, СтрокаГруппировки);
		СтрокиГрафикаОплаты = ТаблицаДанныхДисконтирования.НайтиСтроки(Отбор);
		
		СтрокаГруппировки.НачисленныеПроценты = Окр(СтрокаГруппировки.НачисленныеПроценты, 2);
		СтрокаГруппировки.ПриведеннаяСтоимость = СтрокаГруппировки.ДолгБезНДС - СтрокаГруппировки.НачисленныеПроценты;
		
		СтрокаСМаксимальнымиПроцентами = Неопределено;
		ИтогоПроцентов = 0;
		Для Каждого СтрокаГрафикаОплаты Из СтрокиГрафикаОплаты Цикл
			СтрокаГрафикаОплаты.НачисленныеПроценты = Окр(СтрокаГрафикаОплаты.НачисленныеПроценты, 2);
			СтрокаГрафикаОплаты.ПриведеннаяСтоимость =  СтрокаГрафикаОплаты.ДолгБезНДС - СтрокаГрафикаОплаты.НачисленныеПроценты;
			ИтогоПроцентов = ИтогоПроцентов + СтрокаГрафикаОплаты.НачисленныеПроценты;
			Если СтрокаСМаксимальнымиПроцентами = Неопределено 
				Или СтрокаГрафикаОплаты.НачисленныеПроценты > СтрокаСМаксимальнымиПроцентами.НачисленныеПроценты Тогда
				СтрокаСМаксимальнымиПроцентами = СтрокаГрафикаОплаты;
			КонецЕсли;
		КонецЦикла;
		КорректировкаОкругления = СтрокаГруппировки.НачисленныеПроценты - ИтогоПроцентов;
		Если КорректировкаОкругления <> 0 Тогда
			СтрокаСМаксимальнымиПроцентами.НачисленныеПроценты = СтрокаСМаксимальнымиПроцентами.НачисленныеПроценты + КорректировкаОкругления;
			СтрокаСМаксимальнымиПроцентами.ПриведеннаяСтоимость = СтрокаСМаксимальнымиПроцентами.ПриведеннаяСтоимость - КорректировкаОкругления;
		КонецЕсли;
		
		
		СтрокаГрафикаОплаты = СтрокиГрафикаОплаты[0];
		РазличаетсяФактическаяЗадолженность = СтрокаГруппировки.ДолгБезНДС <> СтрокаГрафикаОплаты.ФиксФактическаяЗадолженностьБезНДС;
		РазличаетсяСтавкаДисконтирования = СтрокаГрафикаОплаты.СтавкаДисконтирования <> СтрокаГрафикаОплаты.ФиксСтавкаДисконтирования;
		РазличаетсяПриведеннаяСтоимость = СтрокаГруппировки.ПриведеннаяСтоимость <> СтрокаГрафикаОплаты.ФиксДисконтированнаяЗадолженностьБезНДС;
		РазличаютсяНачисленныеПроценты = СтрокаГруппировки.НачисленныеПроценты <> СтрокаГрафикаОплаты.ФиксСуммаДисконтирования;
		ВыводитьФиксированные = Не СтрокаГрафикаОплаты.НетФиксированныхЗначений	
			И ( РазличаетсяФактическаяЗадолженность
			Или РазличаетсяСтавкаДисконтирования 
			Или РазличаетсяПриведеннаяСтоимость
			Или РазличаютсяНачисленныеПроценты);
		
		ОбластьШапка = ?(ВыводитьФиксированные, ОбластьШапкаДвеКолонки, ОбластьШапкаОднаКолонка);
		
		ОбластьШапка.Параметры.Заполнить(СтрокаГрафикаОплаты);
		ОбластьШапка.Параметры.Заполнить(СтрокаГруппировки);
		ОбластьШапка.Параметры.СуммаВзаиморасчетов = СтрокаГруппировки.Долг + СтрокаГрафикаОплаты.СуммаАванса;
		Если ВыводитьФиксированные Тогда
			
			ОбластьШапка.Области.ФактическаяЗадолженность.ЦветФона = ?(РазличаетсяФактическаяЗадолженность, WebЦвета.Желтый, Новый Цвет);
			ОбластьШапка.Области.СтавкаДисконтирования.ЦветФона = ?(РазличаетсяСтавкаДисконтирования, WebЦвета.Желтый, Новый Цвет);
			ОбластьШапка.Области.ПриведеннаяСтоимость.ЦветФона = ?(РазличаетсяПриведеннаяСтоимость, WebЦвета.Желтый, Новый Цвет);
			ОбластьШапка.Области.НачисленныеПроценты.ЦветФона = ?(РазличаютсяНачисленныеПроценты, WebЦвета.Желтый, Новый Цвет);
			
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьШапка);
		Если ДанныеОтчета = 1 Тогда
			ОбластьШапкаТаблицы.Параметры.Валюта = СтрокаГрафикаОплаты.Валюта;
		ИначеЕсли ДанныеОтчета = 2 Тогда
			ОбластьШапкаТаблицы.Параметры.Валюта = ЗначениеНастроекПовтИсп.ВалютаУправленческогоУчета();
		ИначеЕсли ДанныеОтчета = 3 Тогда
			ОбластьШапкаТаблицы.Параметры.Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(СтрокаГруппировки.Организация);
		КонецЕсли;
		ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
		
		Для Каждого СтрокаГрафикаОплаты Из СтрокиГрафикаОплаты Цикл
			
			ОбластьСтрока.Параметры.Заполнить(СтрокаГрафикаОплаты);
			ОбластьСтрока.Параметры.ДатаПлановогоПогашения = Формат(СтрокаГрафикаОплаты.ДатаПлановогоПогашения, "ДЛФ=Д");
			
			ТабличныйДокумент.Вывести(ОбластьСтрока);
			
		КонецЦикла;
		
		ОбластьПодвал.Параметры.Заполнить(СтрокаГруппировки);
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		ЕстьДанныеДляОтображения = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ТекстЗапросаВременныхТаблиц()
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеРегистра.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	ДанныеРегистра.ОбъектРасчетов КАК ОбъектРасчетов,
		|	ДанныеРегистра.Валюта КАК Валюта,
		|	ДанныеРегистра.РасчетныйДокумент КАК РасчетныйДокумент,
		|	ВЫБОР &ДанныеОтчета
		|		КОГДА 1
		|			ТОГДА ДанныеРегистра.СуммаДисконтирования
		|		КОГДА 2
		|			ТОГДА ДанныеРегистра.СуммаДисконтированияУпр
		|		ИНАЧЕ ДанныеРегистра.СуммаДисконтированияРегл
		|	КОНЕЦ КАК ФиксСуммаДисконтирования,
		|	ДанныеРегистра.СтавкаДисконтирования КАК ФиксСтавкаДисконтирования,
		|	ВЫБОР &ДанныеОтчета
		|		КОГДА 1
		|			ТОГДА ДанныеРегистра.ДисконтированнаяЗадолженностьБезНДС
		|		КОГДА 2
		|			ТОГДА ДанныеРегистра.ДисконтированнаяЗадолженностьБезНДСУпр
		|		ИНАЧЕ ДанныеРегистра.ДисконтированнаяЗадолженностьБезНДСРегл
		|	КОНЕЦ КАК ФиксДисконтированнаяЗадолженностьБезНДС,
		|	ВЫБОР &ДанныеОтчета
		|		КОГДА 1
		|			ТОГДА ДанныеРегистра.ФактическаяЗадолженностьБезНДС
		|		КОГДА 2
		|			ТОГДА ДанныеРегистра.ФактическаяЗадолженностьБезНДСУпр
		|		ИНАЧЕ ДанныеРегистра.ФактическаяЗадолженностьБезНДСРегл
		|	КОНЕЦ КАК ФиксФактическаяЗадолженностьБезНДС,
		|	КлючиАналитикиУчетаПоПартнерам.Контрагент КАК Контрагент,
		|	КлючиАналитикиУчетаПоПартнерам.Договор КАК Договор,
		|	ДоговорыКонтрагентов.СтавкаДисконтирования КАК СтавкаДисконтирования,
		|	ЕСТЬNULL(ДоговорыКонтрагентов.СтавкаНДС, ЗНАЧЕНИЕ(Справочник.СтавкиНДС.БезНДС)) КАК СтавкаНДС,
		|	ДанныеРегистра.Регистратор КАК Регистратор,
		|	КлючиАналитикиУчетаПоПартнерам.Организация КАК Организация
		|ПОМЕСТИТЬ ВтФикс
		|ИЗ
		|	РегистрНакопления.ПроцентныеРасходыДисконтирования КАК ДанныеРегистра
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаПоПартнерам КАК КлючиАналитикиУчетаПоПартнерам
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|			ПО КлючиАналитикиУчетаПоПартнерам.Договор = ДоговорыКонтрагентов.Ссылка
		|		ПО ДанныеРегистра.АналитикаУчетаПоПартнерам = КлючиАналитикиУчетаПоПартнерам.Ссылка
		|ГДЕ
		|	ДанныеРегистра.Активность
		|	И ДанныеРегистра.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|	И &ОтборПоДоговору
		|	И &ОтборПоДокументу
		|	И ТИПЗНАЧЕНИЯ(ДанныеРегистра.РасчетныйДокумент) В (&ТипыДокументовУчаствующихВДисконтировании)
		|	И ТИПЗНАЧЕНИЯ(ДанныеРегистра.Регистратор) <> ТИП(Документ.РасчетКурсовыхРазниц)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	АналитикаУчетаПоПартнерам,
		|	ОбъектРасчетов,
		|	Валюта,
		|	РасчетныйДокумент,
		|	Регистратор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВтФикс.Контрагент КАК Контрагент,
		|	ВтФикс.Договор КАК Договор,
		|	РасчетыСПоставщикамиПоСрокам.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	РасчетыСПоставщикамиПоСрокам.ОбъектРасчетов КАК ОбъектРасчетов,
		|	РасчетыСПоставщикамиПоСрокам.РасчетныйДокумент КАК РасчетныйДокумент,
		|	РасчетыСПоставщикамиПоСрокам.Валюта КАК Валюта,
		|	ВтФикс.СтавкаДисконтирования КАК СтавкаДисконтирования,
		|	РасчетыСПоставщикамиПоСрокам.ДатаВозникновения КАК ДатаВозникновения,
		|	РасчетыСПоставщикамиПоСрокам.ДатаПлановогоПогашения КАК ДатаПлановогоПогашения,
		|	ВЫБОР
		|		КОГДА РасчетыСПоставщикамиПоСрокам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА 1
		|		ИНАЧЕ -1
		|	КОНЕЦ * ВЫБОР &ДанныеОтчета
		|		КОГДА 1
		|			ТОГДА РасчетыСПоставщикамиПоСрокам.Долг
		|		КОГДА 2
		|			ТОГДА РасчетыСПоставщикамиПоСрокам.ДолгУпр
		|		ИНАЧЕ РасчетыСПоставщикамиПоСрокам.ДолгРегл
		|	КОНЕЦ КАК Долг,
		|	ВЫБОР
		|		КОГДА РасчетыСПоставщикамиПоСрокам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|			ТОГДА ВЫБОР &ДанныеОтчета
		|					КОГДА 1
		|						ТОГДА РасчетыСПоставщикамиПоСрокам.Долг
		|					КОГДА 2
		|						ТОГДА РасчетыСПоставщикамиПоСрокам.ДолгУпр
		|					ИНАЧЕ РасчетыСПоставщикамиПоСрокам.ДолгРегл
		|				КОНЕЦ
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СуммаАванса,
		|	РасчетыСПоставщикамиПоСрокам.ДокументРегистратор КАК ДокументРегистратор,
		|	РАЗНОСТЬДАТ(РасчетыСПоставщикамиПоСрокам.ДатаВозникновения, РасчетыСПоставщикамиПоСрокам.ДатаПлановогоПогашения, ДЕНЬ) КАК КоличествоДнейДоПлатежа,
		|	ВтФикс.ФиксСуммаДисконтирования КАК ФиксСуммаДисконтирования,
		|	ВтФикс.ФиксСтавкаДисконтирования КАК ФиксСтавкаДисконтирования,
		|	ВтФикс.ФиксФактическаяЗадолженностьБезНДС КАК ФиксФактическаяЗадолженностьБезНДС,
		|	ВтФикс.ФиксДисконтированнаяЗадолженностьБезНДС КАК ФиксДисконтированнаяЗадолженностьБезНДС,
		|	ВтФикс.ФиксСуммаДисконтирования ЕСТЬ NULL КАК НетФиксированныхЗначений,
		|	ВтФикс.СтавкаНДС КАК СтавкаНДС,
		|	ВтФикс.Организация КАК Организация
		|ПОМЕСТИТЬ ВтГрафик
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщикамиПоСрокам КАК РасчетыСПоставщикамиПоСрокам
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтФикс КАК ВтФикс
		|		ПО РасчетыСПоставщикамиПоСрокам.АналитикаУчетаПоПартнерам = ВтФикс.АналитикаУчетаПоПартнерам
		|			И РасчетыСПоставщикамиПоСрокам.ОбъектРасчетов = ВтФикс.ОбъектРасчетов
		|			И РасчетыСПоставщикамиПоСрокам.Валюта = ВтФикс.Валюта
		|			И РасчетыСПоставщикамиПоСрокам.РасчетныйДокумент = ВтФикс.РасчетныйДокумент
		|			И РасчетыСПоставщикамиПоСрокам.ДокументРегистратор = ВтФикс.Регистратор
		|ГДЕ
		|	РасчетыСПоставщикамиПоСрокам.Активность
		|	И РасчетыСПоставщикамиПоСрокам.Долг <> 0
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ДокументРегистратор";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаСКоэффициентамиСуммыНДС()
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	СуммыДокументовВВалютахУчета.Регистратор КАК Регистратор,
		|	ВЫБОР
		|		КОГДА СУММА(СуммыДокументовВВалютахУчета.СуммаВзаиморасчетов) = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВЫРАЗИТЬ(СУММА(СуммыДокументовВВалютахУчета.СуммаВзаиморасчетов - СуммыДокументовВВалютахУчета.СуммаНДСВзаиморасчетов) / СУММА(СуммыДокументовВВалютахУчета.СуммаВзаиморасчетов) КАК ЧИСЛО(11, 10))
		|	КОНЕЦ КАК КоэффициентСуммыБезНДС
		|ПОМЕСТИТЬ ВтКоэффициентыСуммыНДС
		|ИЗ
		|	РегистрСведений.СуммыДокументовВВалютахУчета КАК СуммыДокументовВВалютахУчета
		|ГДЕ
		|	СуммыДокументовВВалютахУчета.Регистратор В
		|			(ВЫБРАТЬ
		|				ВтГрафик.ДокументРегистратор
		|			ИЗ
		|				ВтГрафик)
		|	И СуммыДокументовВВалютахУчета.Активность
		|
		|СГРУППИРОВАТЬ ПО
		|	СуммыДокументовВВалютахУчета.Регистратор
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Регистратор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВтГрафик.Контрагент КАК Контрагент,
		|	ВтГрафик.Договор КАК Договор,
		|	ВтГрафик.ОбъектРасчетов КАК ОбъектРасчетов,
		|	ВтГрафик.РасчетныйДокумент КАК РасчетныйДокумент,
		|	ВтГрафик.Валюта КАК Валюта,
		|	ВтГрафик.СтавкаДисконтирования КАК СтавкаДисконтирования,
		|	ВтГрафик.ДатаВозникновения КАК ДатаВозникновения,
		|	ВтГрафик.ДатаПлановогоПогашения КАК ДатаПлановогоПогашения,
		|	ВтГрафик.СтавкаНДС КАК СтавкаНДС,
		|	СУММА(ВтГрафик.Долг) КАК Долг,
		|	ВтГрафик.КоличествоДнейДоПлатежа КАК КоличествоДнейДоПлатежа,
		|	ЕСТЬNULL(ВтКоэффициентыСуммыНДС.КоэффициентСуммыБезНДС, 1) КАК КоэффициентСуммыБезНДС,
		|	ВтГрафик.ФиксСуммаДисконтирования КАК ФиксСуммаДисконтирования,
		|	ВтГрафик.ФиксСтавкаДисконтирования КАК ФиксСтавкаДисконтирования,
		|	ВтГрафик.ФиксФактическаяЗадолженностьБезНДС КАК ФиксФактическаяЗадолженностьБезНДС,
		|	ВтГрафик.ФиксДисконтированнаяЗадолженностьБезНДС КАК ФиксДисконтированнаяЗадолженностьБезНДС,
		|	ВтГрафик.НетФиксированныхЗначений КАК НетФиксированныхЗначений,
		|	СУММА(ВтГрафик.СуммаАванса) КАК СуммаАванса,
		|	СУММА(ВЫРАЗИТЬ(ЕСТЬNULL(ВтКоэффициентыСуммыНДС.КоэффициентСуммыБезНДС, 0) * ВтГрафик.СуммаАванса КАК ЧИСЛО(31, 2))) КАК СуммаАвансаБезНДС,
		|	ВтГрафик.Организация КАК Организация
		|ИЗ
		|	ВтГрафик КАК ВтГрафик
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтКоэффициентыСуммыНДС КАК ВтКоэффициентыСуммыНДС
		|		ПО ВтГрафик.ДокументРегистратор = ВтКоэффициентыСуммыНДС.Регистратор
		|
		|СГРУППИРОВАТЬ ПО
		|	ВтГрафик.Контрагент,
		|	ВтГрафик.Договор,
		|	ВтГрафик.ОбъектРасчетов,
		|	ВтГрафик.РасчетныйДокумент,
		|	ВтГрафик.Валюта,
		|	ВтГрафик.СтавкаДисконтирования,
		|	ВтГрафик.ДатаВозникновения,
		|	ВтГрафик.ДатаПлановогоПогашения,
		|	ВтГрафик.СтавкаНДС,
		|	ВтГрафик.КоличествоДнейДоПлатежа,
		|	ВтКоэффициентыСуммыНДС.КоэффициентСуммыБезНДС,
		|	ВтГрафик.ФиксСуммаДисконтирования,
		|	ВтГрафик.ФиксСтавкаДисконтирования,
		|	ВтГрафик.ФиксФактическаяЗадолженностьБезНДС,
		|	ВтГрафик.ФиксДисконтированнаяЗадолженностьБезНДС,
		|	ВтГрафик.НетФиксированныхЗначений,
		|	ВтГрафик.Организация";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ПолучитьДанныеДисконтирования(ОтборДоговор, ОтборДокументы, ДанныеОтчета)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТипыДокументовУчаствующихВДисконтировании", 
		РегистрыНакопления.ПроцентныеРасходыДисконтирования.ПолучитьТипыДокументовУчаствующихВДисконтировании());
	Запрос.УстановитьПараметр("ДанныеОтчета", ДанныеОтчета);
	
	Запрос.Текст = ТекстЗапросаВременныхТаблиц();
	
	Если ЗначениеЗаполнено(ОтборДоговор) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоДоговору", "КлючиАналитикиУчетаПоПартнерам.Договор В (&Договор)");
		Запрос.УстановитьПараметр("Договор", ОтборДоговор);
	Иначе
		Запрос.УстановитьПараметр("ОтборПоДоговору", Истина);
	КонецЕсли;
	Если ОтборДокументы.Количество() > 0 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоДокументу", "ДанныеРегистра.Регистратор В (&Документы)");
		Запрос.УстановитьПараметр("Документы", ОтборДокументы);
	Иначе 
		Запрос.УстановитьПараметр("ОтборПоДокументу", Истина);
	КонецЕсли;
	
	Запрос.Выполнить();
	
	Запрос.Текст = ТекстЗапросаСКоэффициентамиСуммыНДС();
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаРезультат = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ТаблицаРезультат.Колонки.Добавить("НачисленныеПроценты", ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	ТаблицаРезультат.Колонки.Добавить("ДолгБезНДС", ОбщегоНазначенияУТ.ОписаниеТиповПоТипу(Тип("Число")));
	ТаблицаРезультат.Колонки.Добавить("ПриведеннаяСтоимость", ОбщегоНазначенияУТ.ОписаниеТиповПоТипу(Тип("Число")));
	ТаблицаРезультат.Индексы.Добавить("РасчетныйДокумент, ОбъектРасчетов");
	
	ТаблицаГруппировка = ТаблицаРезультат.Скопировать(,"РасчетныйДокумент, ОбъектРасчетов");
	ТаблицаГруппировка.Свернуть("РасчетныйДокумент, ОбъектРасчетов");
	
	Отбор = Новый Структура("РасчетныйДокумент, ОбъектРасчетов");
	Для Каждого СтрокаГруппировки Из ТаблицаГруппировка Цикл
		ЗаполнитьЗначенияСвойств(Отбор, СтрокаГруппировки);
		СтрокиГрафика = ТаблицаРезультат.НайтиСтроки(Отбор);
		ИтогоПриведеннаяСтоимость = 0;
		ИтогоОкрПриведеннаяСтоимость = 0;
		СтрокаМаксимум = Неопределено;
		Для Каждого СтрокаТаблицы Из СтрокиГрафика Цикл
			СтрокаТаблицы.ДолгБезНДС = СтрокаТаблицы.Долг * СтрокаТаблицы.КоэффициентСуммыБезНДС;
			Если ТипЗнч(СтрокаТаблицы.РасчетныйДокумент) = Тип("ДокументСсылка.ПервичныйДокумент") Тогда
				СтавкаНДС = УчетНДСУПКлиентСервер.ЗначениеСтавкиНДС(СтрокаТаблицы.СтавкаНДС) / 100;
				СтрокаТаблицы.ДолгБезНДС = Окр(СтрокаТаблицы.Долг / (1 + СтавкаНДС), 2);
				СтрокаТаблицы.СуммаАвансаБезНДС = Окр(СтрокаТаблицы.СуммаАванса / (1 + СтавкаНДС), 2);
			КонецЕсли;
			СтрокаТаблицы.ПриведеннаяСтоимость = СтрокаТаблицы.ДолгБезНДС
				/ Pow((1+СтрокаТаблицы.СтавкаДисконтирования/100), СтрокаТаблицы.КоличествоДнейДоПлатежа/365);
			ИтогоПриведеннаяСтоимость = ИтогоПриведеннаяСтоимость + СтрокаТаблицы.ПриведеннаяСтоимость;
			СтрокаТаблицы.ПриведеннаяСтоимость = Окр(СтрокаТаблицы.ПриведеннаяСтоимость, 2);
			ИтогоОкрПриведеннаяСтоимость = ИтогоОкрПриведеннаяСтоимость + СтрокаТаблицы.ПриведеннаяСтоимость;
			Если СтрокаМаксимум = Неопределено Или СтрокаМаксимум.ПриведеннаяСтоимость < СтрокаТаблицы.ПриведеннаяСтоимость Тогда
				СтрокаМаксимум = СтрокаТаблицы;
			КонецЕсли;
		КонецЦикла;
		ИтогоПриведеннаяСтоимость = Окр(ИтогоПриведеннаяСтоимость, 2);
		Остаток = ИтогоПриведеннаяСтоимость - ИтогоОкрПриведеннаяСтоимость;
		Если Остаток <> 0 Тогда
			СтрокаМаксимум.ПриведеннаяСтоимость = СтрокаМаксимум.ПриведеннаяСтоимость + Остаток;
		КонецЕсли;
		Для Каждого СтрокаТаблицы Из СтрокиГрафика Цикл
			СтрокаТаблицы.ДолгБезНДС = Окр(СтрокаТаблицы.ДолгБезНДС, 2);
			СтрокаТаблицы.НачисленныеПроценты = СтрокаТаблицы.ДолгБезНДС - СтрокаТаблицы.ПриведеннаяСтоимость;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ТаблицаРезультат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
