﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		Или РасчетСебестоимостиПрикладныеАлгоритмы.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ РасчетСебестоимостиПрикладныеАлгоритмы.ФормироватьДвиженияРегистровУчетаСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	РасчетСебестоимостиПрикладныеАлгоритмы.СохранитьДвиженияСформированныеРасчетомПартийИСебестоимости(ЭтотОбъект, Замещение);
	
	Если Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства)
		Или ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	*
	|ПОМЕСТИТЬ ДетализацияПартийТоваровДляНДСиУСН2_4ПередЗаписью
	|ИЗ
	|	РегистрНакопления.ДетализацияПартийТоваровДляНДСиУСН2_4 КАК Т
	|ГДЕ
	|	Т.Регистратор = &Регистратор";
	
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства)
		Или ПланыОбмена.ГлавныйУзел() <> Неопределено
		Или РасчетСебестоимостиПрикладныеАлгоритмы.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ РасчетСебестоимостиПрикладныеАлгоритмы.ФормироватьДвиженияРегистровУчетаСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	Таблица.Период КАК Период,
	|	Таблица.Регистратор КАК Регистратор,
	|	Таблица.Организация КАК Организация,
	|	Таблица.Партия КАК Партия,
	|	Таблица.АналитикаУчетаПартий КАК АналитикаУчетаПартий,
	|	Таблица.ВидДеятельностиНДС КАК ВидДеятельностиНДС,
	|	Таблица.ДокументПоступления КАК ДокументПоступления,
	|	Таблица.АналитикаУчетаДокументаПоступления КАК АналитикаУчетаДокументаПоступления,
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	Таблица.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	Таблица.КорВидДеятельностиНДС КАК КорВидДеятельностиНДС,
	|	Таблица.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|	Таблица.КорВидЗапасов КАК КорВидЗапасов,
	|	Таблица.СтатьяРасходовАктивов КАК СтатьяРасходовАктивов,
	|	Таблица.АналитикаРасходов КАК АналитикаРасходов,
	|	Таблица.АналитикаАктивов КАК АналитикаАктивов,
	|	Таблица.ДокументИсточник КАК ДокументИсточник,
	|	Таблица.Знаменатель КАК Знаменатель,
	|	Таблица.СтатьяСписанияНДС КАК СтатьяСписанияНДС,
	|	Таблица.АналитикаСписанияНДС КАК АналитикаСписанияНДС,
	|	Таблица.ТипЗаписи КАК ТипЗаписи,
	|	Таблица.РасчетПартий КАК РасчетПартий,
	|	Таблица.РасчетНеЗавершен КАК РасчетНеЗавершен,
	|	СУММА(Таблица.СтоимостьБезНДС) КАК СтоимостьБезНДСИзменение,
	|	СУММА(Таблица.НДС) КАК НДСИзменение,
	|	СУММА(Таблица.СтоимостьБезНДСУпр) КАК СтоимостьБезНДСУпрИзменение,
	|	СУММА(Таблица.НДСУпр) КАК НДСУпрИзменение
	|ПОМЕСТИТЬ ТаблицаИзмененийДетализацияПартийТоваровДляНДСиУСН2_4
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДетализацияПартий.Период КАК Период,
	|		ДетализацияПартий.Регистратор КАК Регистратор,
	|		ДетализацияПартий.Организация КАК Организация,
	|		ДетализацияПартий.Партия КАК Партия,
	|		ДетализацияПартий.АналитикаУчетаПартий КАК АналитикаУчетаПартий,
	|		ДетализацияПартий.ВидДеятельностиНДС КАК ВидДеятельностиНДС,
	|		ДетализацияПартий.ДокументПоступления КАК ДокументПоступления,
	|		ДетализацияПартий.АналитикаУчетаДокументаПоступления КАК АналитикаУчетаДокументаПоступления,
	|		ДетализацияПартий.Номенклатура КАК Номенклатура,
	|		ДетализацияПартий.Характеристика КАК Характеристика,
	|		ДетализацияПартий.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|		ДетализацияПартий.СтоимостьБезНДС КАК СтоимостьБезНДС,
	|		ДетализацияПартий.НДС КАК НДС,
	|		ДетализацияПартий.СтоимостьБезНДСУпр КАК СтоимостьБезНДСУпр,
	|		ДетализацияПартий.НДСУпр КАК НДСУпр,
	|		ДетализацияПартий.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|		ДетализацияПартий.КорВидДеятельностиНДС КАК КорВидДеятельностиНДС,
	|		ДетализацияПартий.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|		ДетализацияПартий.КорВидЗапасов КАК КорВидЗапасов,
	|		ДетализацияПартий.СтатьяРасходовАктивов КАК СтатьяРасходовАктивов,
	|		ДетализацияПартий.АналитикаРасходов КАК АналитикаРасходов,
	|		ДетализацияПартий.АналитикаАктивов КАК АналитикаАктивов,
	|		ДетализацияПартий.ДокументИсточник КАК ДокументИсточник,
	|		ДетализацияПартий.Знаменатель КАК Знаменатель,
	|		ДетализацияПартий.СтатьяСписанияНДС КАК СтатьяСписанияНДС,
	|		ДетализацияПартий.АналитикаСписанияНДС КАК АналитикаСписанияНДС,
	|		ДетализацияПартий.ТипЗаписи КАК ТипЗаписи,
	|		ДетализацияПартий.РасчетПартий КАК РасчетПартий,
	|		ДетализацияПартий.РасчетНеЗавершен КАК РасчетНеЗавершен
	|	ИЗ
	|		ДетализацияПартийТоваровДляНДСиУСН2_4ПередЗаписью КАК ДетализацияПартий
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ДетализацияПартий.Период КАК Период,
	|		ДетализацияПартий.Регистратор КАК Регистратор,
	|		ДетализацияПартий.Организация КАК Организация,
	|		ДетализацияПартий.Партия КАК Партия,
	|		ДетализацияПартий.АналитикаУчетаПартий КАК АналитикаУчетаПартий,
	|		ДетализацияПартий.ВидДеятельностиНДС КАК ВидДеятельностиНДС,
	|		ДетализацияПартий.ДокументПоступления КАК ДокументПоступления,
	|		ДетализацияПартий.АналитикаУчетаДокументаПоступления КАК АналитикаУчетаДокументаПоступления,
	|		ДетализацияПартий.Номенклатура КАК Номенклатура,
	|		ДетализацияПартий.Характеристика КАК Характеристика,
	|		ДетализацияПартий.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|		-ДетализацияПартий.СтоимостьБезНДС КАК СтоимостьБезНДС,
	|		-ДетализацияПартий.НДС КАК НДС,
	|		-ДетализацияПартий.СтоимостьБезНДСУпр КАК СтоимостьБезНДСУпр,
	|		-ДетализацияПартий.НДСУпр КАК НДСУпр,
	|		ДетализацияПартий.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|		ДетализацияПартий.КорВидДеятельностиНДС КАК КорВидДеятельностиНДС,
	|		ДетализацияПартий.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|		ДетализацияПартий.КорВидЗапасов КАК КорВидЗапасов,
	|		ДетализацияПартий.СтатьяРасходовАктивов КАК СтатьяРасходовАктивов,
	|		ДетализацияПартий.АналитикаРасходов КАК АналитикаРасходов,
	|		ДетализацияПартий.АналитикаАктивов КАК АналитикаАктивов,
	|		ДетализацияПартий.ДокументИсточник КАК ДокументИсточник,
	|		ДетализацияПартий.Знаменатель КАК Знаменатель,
	|		ДетализацияПартий.СтатьяСписанияНДС КАК СтатьяСписанияНДС,
	|		ДетализацияПартий.АналитикаСписанияНДС КАК АналитикаСписанияНДС,
	|		ДетализацияПартий.ТипЗаписи КАК ТипЗаписи,
	|		ДетализацияПартий.РасчетПартий КАК РасчетПартий,
	|		ДетализацияПартий.РасчетНеЗавершен КАК РасчетНеЗавершен
	|	ИЗ
	|		РегистрНакопления.ДетализацияПартийТоваровДляНДСиУСН2_4 КАК ДетализацияПартий
	|	ГДЕ
	|		ДетализацияПартий.Регистратор = &Регистратор) КАК Таблица
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.Организация,
	|	Таблица.Партия,
	|	Таблица.АналитикаУчетаПартий,
	|	Таблица.ВидДеятельностиНДС,
	|	Таблица.ДокументПоступления,
	|	Таблица.АналитикаУчетаДокументаПоступления,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.НаправлениеДеятельности,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.КорВидДеятельностиНДС,
	|	Таблица.КорАналитикаУчетаНоменклатуры,
	|	Таблица.КорВидЗапасов,
	|	Таблица.СтатьяРасходовАктивов,
	|	Таблица.АналитикаРасходов,
	|	Таблица.АналитикаАктивов,
	|	Таблица.ДокументИсточник,
	|	Таблица.Знаменатель,
	|	Таблица.СтатьяСписанияНДС,
	|	Таблица.АналитикаСписанияНДС,
	|	Таблица.ТипЗаписи,
	|	Таблица.РасчетПартий,
	|	Таблица.РасчетНеЗавершен
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.СтоимостьБезНДС) <> 0
	|	И СУММА(Таблица.НДС) <> 0
	|	И СУММА(Таблица.СтоимостьБезНДСУпр) <> 0
	|	И СУММА(Таблица.НДСУпр) <> 0
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДетализацияПартийТоваровДляНДСиУСН2_4ПередЗаписью");
	
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();

КонецПроцедуры

#КонецОбласти

#КонецЕсли
