﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		Или РасчетСебестоимостиПрикладныеАлгоритмы.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	
	ДополнительныеСвойства.Вставить("ПартионныйУчетВключен",
		РасчетСебестоимостиПовтИсп.ПартионныйУчетВключен(
			НачалоМесяца(ДополнительныеСвойства.ДатаРегистратора)));
	
	Если Константы.КонтролироватьОстаткиТоваровОрганизаций.Получить()
		Или ДополнительныеСвойства.ПартионныйУчетВключен Тогда
		
		ЗапасыСервер.СохранитьИсходныеДвиженияТоваровИРезервов(Отбор.Регистратор.Значение,
			ДополнительныеСвойства.МенеджерВременныхТаблиц);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		Или Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства)
		Или РасчетСебестоимостиПрикладныеАлгоритмы.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не (Константы.КонтролироватьОстаткиТоваровОрганизаций.Получить()
		Или ДополнительныеСвойства.ПартионныйУчетВключен) Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	МИНИМУМ(ВложенныйЗапрос.Период) КАК Период,
	|	ВложенныйЗапрос.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ВложенныйЗапрос.Организация КАК Организация,
	|	ВложенныйЗапрос.ВидЗапасов КАК ВидЗапасов,
	|	ВложенныйЗапрос.НомерГТД КАК НомерГТД,
	|	СУММА(ВложенныйЗапрос.КоличествоИзменение) КАК КоличествоИзменение
	|ПОМЕСТИТЬ ВТДвиженияТоварыОрганизацийИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаИзменений.Период КАК Период,
	|		ТаблицаИзменений.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаИзменений.Организация КАК Организация,
	|		ТаблицаИзменений.ВидЗапасов КАК ВидЗапасов,
	|		ТаблицаИзменений.НомерГТД КАК НомерГТД,
	|		СУММА(ТаблицаИзменений.КоличествоИзменение) КАК КоличествоИзменение
	|	ИЗ
	|		(ВЫБРАТЬ
	|			КОНЕЦПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК Период,
	|			Таблица.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|			Таблица.Организация КАК Организация,
	|			Таблица.ВидЗапасов КАК ВидЗапасов,
	|			Таблица.НомерГТД КАК НомерГТД,
	|			ВЫБОР Таблица.ВидДвижения
	|				КОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|					ТОГДА -Таблица.Количество
	|				ИНАЧЕ Таблица.Количество
	|			КОНЕЦ КАК КоличествоИзменение
	|		ИЗ
	|			ДвиженияТоварыОрганизацийПередЗаписью КАК Таблица
	|		ГДЕ
	|			&КонтролироватьОстатки
	|			И НЕ &ЭтоОбменДанными
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			КОНЕЦПЕРИОДА(Таблица.Период, МЕСЯЦ),
	|			Таблица.АналитикаУчетаНоменклатуры,
	|			Таблица.Организация,
	|			Таблица.ВидЗапасов,
	|			Таблица.НомерГТД,
	|			ВЫБОР Таблица.ВидДвижения
	|				КОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|					ТОГДА Таблица.Количество
	|				ИНАЧЕ -Таблица.Количество
	|			КОНЕЦ
	|		ИЗ
	|			РегистрНакопления.ТоварыОрганизаций КАК Таблица
	|		ГДЕ
	|			Таблица.Регистратор = &Регистратор
	|			И &КонтролироватьОстатки
	|			И НЕ &ЭтоОбменДанными) КАК ТаблицаИзменений
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТаблицаИзменений.АналитикаУчетаНоменклатуры,
	|		ТаблицаИзменений.Организация,
	|		ТаблицаИзменений.ВидЗапасов,
	|		ТаблицаИзменений.НомерГТД,
	|		ТаблицаИзменений.Период
	|	
	|	ИМЕЮЩИЕ
	// Проверяем только уменьшение остатка
	|		СУММА(ТаблицаИзменений.КоличествоИзменение) < 0) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.АналитикаУчетаНоменклатуры,
	|	ВложенныйЗапрос.Организация,
	|	ВложенныйЗапрос.ВидЗапасов,
	|	ВложенныйЗапрос.НомерГТД
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДвиженияТоварыОрганизацийИзменение.Период КАК Период,
	|	ДвиженияТоварыОрганизацийИзменение.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ДвиженияТоварыОрганизацийИзменение.Организация КАК Организация,
	|	ДвиженияТоварыОрганизацийИзменение.ВидЗапасов КАК ВидЗапасов,
	|	ДвиженияТоварыОрганизацийИзменение.НомерГТД КАК НомерГТД,
	|	ДвиженияТоварыОрганизацийИзменение.КоличествоИзменение КАК КоличествоИзменение
	|ПОМЕСТИТЬ ДвиженияТоварыОрганизацийИзменение
	|ИЗ
	|	ВТДвиженияТоварыОрганизацийИзменение КАК ДвиженияТоварыОрганизацийИзменение
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючиАналитикиУчетаНоменклатуры
	|		ПО ДвиженияТоварыОрганизацийИзменение.АналитикаУчетаНоменклатуры = КлючиАналитикиУчетаНоменклатуры.Ссылка
	|ГДЕ
	|	НЕ КлючиАналитикиУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.Подразделение)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДвиженияТоварыОрганизацийИзменение.АналитикаУчетаНоменклатуры.Номенклатура   КАК Номенклатура,
	|	ДвиженияТоварыОрганизацийИзменение.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	ДвиженияТоварыОрганизацийИзменение.АналитикаУчетаНоменклатуры.Договор        КАК Договор,
	|	ДвиженияТоварыОрганизацийИзменение.КоличествоИзменение                       КАК КоличествоИзменение
	|ПОМЕСТИТЬ ДвиженияТоварыОрганизацийИзменениеСводно
	|ИЗ
	|	ВТДвиженияТоварыОрганизацийИзменение КАК ДвиженияТоварыОрганизацийИзменение
	|ГДЕ
	|	&ФормироватьСводнуюТаблицу
	|	И ДвиженияТоварыОрганизацийИзменение.АналитикаУчетаНоменклатуры.Договор <> ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Договор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияТоварыОрганизацийИзменение.Период) КАК Период
	|ИЗ
	|	ДвиженияТоварыОрганизацийИзменение КАК ДвиженияТоварыОрганизацийИзменение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Период КАК Период,
	|	Таблица.Регистратор КАК Регистратор,
	|	Таблица.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Таблица.Организация КАК Организация,
	|	Таблица.ВидЗапасов КАК ВидЗапасов,
	|	Таблица.НомерГТД КАК НомерГТД,
	|	Таблица.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	Таблица.НалогообложениеНДС КАК НалогообложениеНДС,
	|	Таблица.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|	Таблица.КорВидЗапасов КАК КорВидЗапасов,
	|	Таблица.ОрганизацияОтгрузки КАК ОрганизацияОтгрузки,
	|	Таблица.ДокументРеализации КАК ДокументРеализации,
	|	Таблица.СтатьяРасходов КАК СтатьяРасходов,
	|	Таблица.АналитикаРасходов КАК АналитикаРасходов,
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.Первичное КАК Первичное,
	|	СУММА(Таблица.Количество) КАК КоличествоИзменение
	|ПОМЕСТИТЬ ТаблицаИзмененийТоварыОрганизаций
	|ИЗ
	|	(ВЫБРАТЬ
	|		Товары.Период КАК Период,
	|		Товары.Регистратор КАК Регистратор,
	|		Товары.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		Товары.Организация КАК Организация,
	|		Товары.ВидЗапасов КАК ВидЗапасов,
	|		Товары.НомерГТД КАК НомерГТД,
	|		Товары.Количество КАК Количество,
	|		Товары.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|		Товары.НалогообложениеНДС КАК НалогообложениеНДС,
	|		Товары.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|		Товары.КорВидЗапасов КАК КорВидЗапасов,
	|		Товары.ОрганизацияОтгрузки КАК ОрганизацияОтгрузки,
	|		Товары.ДокументРеализации КАК ДокументРеализации,
	|		Товары.СтатьяРасходов КАК СтатьяРасходов,
	|		Товары.АналитикаРасходов КАК АналитикаРасходов,
	|		Товары.Номенклатура КАК Номенклатура,
	|		Товары.Характеристика КАК Характеристика,
	|		Товары.Первичное КАК Первичное
	|	ИЗ
	|		ДвиженияТоварыОрганизацийПередЗаписью КАК Товары
	|	ГДЕ
	|		&ПартионныйУчетВключен
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Товары.Период,
	|		Товары.Регистратор,
	|		Товары.АналитикаУчетаНоменклатуры,
	|		Товары.Организация,
	|		Товары.ВидЗапасов,
	|		Товары.НомерГТД,
	|		-Товары.Количество,
	|		Товары.ХозяйственнаяОперация,
	|		Товары.НалогообложениеНДС,
	|		Товары.КорАналитикаУчетаНоменклатуры,
	|		Товары.КорВидЗапасов,
	|		Товары.ОрганизацияОтгрузки,
	|		Товары.ДокументРеализации,
	|		Товары.СтатьяРасходов,
	|		Товары.АналитикаРасходов,
	|		Товары.Номенклатура,
	|		Товары.Характеристика,
	|		Товары.Первичное
	|	ИЗ
	|		РегистрНакопления.ТоварыОрганизаций КАК Товары
	|	ГДЕ
	|		Товары.Регистратор = &Регистратор
	|		И &ПартионныйУчетВключен) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.АналитикаУчетаНоменклатуры,
	|	Таблица.Организация,
	|	Таблица.ВидЗапасов,
	|	Таблица.НомерГТД,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.НалогообложениеНДС,
	|	Таблица.КорАналитикаУчетаНоменклатуры,
	|	Таблица.КорВидЗапасов,
	|	Таблица.ОрганизацияОтгрузки,
	|	Таблица.ДокументРеализации,
	|	Таблица.СтатьяРасходов,
	|	Таблица.АналитикаРасходов,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.Первичное
	|
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Количество) <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДвиженияТоварыОрганизацийИзменение.ВидЗапасов КАК ВидЗапасов
	|ИЗ
	|	ВТДвиженияТоварыОрганизацийИзменение КАК ВТДвиженияТоварыОрганизацийИзменение
	|ГДЕ
	|	(ВТДвиженияТоварыОрганизацийИзменение.ВидЗапасов.Устаревший
	|			ИЛИ ВТДвиженияТоварыОрганизацийИзменение.ВидЗапасов.ЭтоДубль)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТДвиженияТоварыОрганизацийИзменение";

	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоОбменДанными", ОбменДанными.Загрузка);
	Запрос.УстановитьПараметр("КонтролироватьОстатки", Константы.КонтролироватьОстаткиТоваровОрганизаций.Получить());
	Запрос.УстановитьПараметр("ПартионныйУчетВключен", ДополнительныеСвойства.ПартионныйУчетВключен);
	
	ФормироватьСводнуюТаблицу = ДополнительныеСвойства.Свойство("ФормироватьСводнуюТаблицуТоварыОрганизаций");
	Запрос.УстановитьПараметр("ФормироватьСводнуюТаблицу", ФормироватьСводнуюТаблицу);
	
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.ВыполнитьПакет();
	
	МинимальныйПериод = Результат[3].Выбрать();
	Если МинимальныйПериод.Следующий() Тогда
		МинимальныйПериод = МинимальныйПериод.Период;
	Иначе
		МинимальныйПериод = Дата('00010101');
	КонецЕсли;
	
	Выборка = Результат[1].Выбрать();
	ПроведениеДокументов.ЗарегистрироватьТаблицуКонтроля(ДополнительныеСвойства, "ДвиженияТоварыОрганизацийИзменение",
		Выборка.Следующий() И Выборка.Количество > 0, Новый Структура("МинимальныйПериод", МинимальныйПериод));
	
	Выборка = Результат[2].Выбрать();
	ПроведениеДокументов.ЗарегистрироватьТаблицуКонтроля(ДополнительныеСвойства,
		"ДвиженияТоварыОрганизацийИзменениеСводно", Выборка.Следующий() И Выборка.Количество > 0);
	
	УстаревшиеВидыЗапасовДляОбновленияЗапиейВРС = Результат[5].Выгрузить().ВыгрузитьКолонку("ВидЗапасов");
	РегистрыСведений.УстаревшиеВидыЗапасовСОстатками.ОбновитьЗаписи(УстаревшиеВидыЗапасовДляОбновленияЗапиейВРС);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
