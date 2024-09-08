﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура по переданной ссылке на заказ расчитывает и записывает в регистр сведений состояние заказа.
//
//	Параметры:
//		МассивЗаказов - Массив - Массив документов типов ЗаказНаПеремещение, ЗаказНаСборку, ЗаказНаВнутреннееПотребление
//								 в рамках проведения которого перерасчитывается состояние.
//
Процедура ОтразитьСостояниеЗаказа(МассивЗаказов) Экспорт
	
	ЗаказыПоТипам = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивЗаказов);
	
	Для Каждого Элемент Из ЗаказыПоТипам Цикл
		
		ТипЗаказа = Элемент.Ключ;
		Заказы = Элемент.Значение;
		
		Если ТипЗаказа = "Документ.ЗаказНаПеремещение"
				Или ТипЗаказа = "Документ.ЗаказНаСборку"
				Или ТипЗаказа = "Документ.ЗаказНаВнутреннееПотребление" Тогда
			
			Таблица = ТаблицаИзмененийСостоянийЗаказов(ТипЗаказа, Заказы);
			ЗаписатьСостояния(Таблица);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Отражает изменения состояний заказов в регистре.
//
// Параметры:
//  ДокументИсточник - ДокументОбъект - записываемый документ.
//  МассивЗаказов - Массив из ДокументСсылка - массив отражаемых заказов.
//
Процедура ОтразитьСостоянияЗаказов(ДокументИсточник, МассивЗаказов) Экспорт
	
	ОтразитьСостояниеЗаказа(МассивЗаказов);
	
КонецПроцедуры

// Дополняет текст запроса механизма расчета состояний.
// 
// Параметры:
// 	Запрос - Запрос - используется для установки параметров запроса.
// 
// Возвращаемое значение:
//	Соответствие - соответствие имен таблиц изменения регистров и текстов запросов.
//	
Функция СоответствиеЗапросовКонтрольнымРегистрам(Запрос) Экспорт

	СоответствиеЗаданий = Новый Соответствие();
	СоответствиеЗаданий.Вставить("ДвиженияТоварыКОтгрузкеИзменение", ТекстЗапросаТоварыКОтгрузке(Запрос));
	СоответствиеЗаданий.Вставить("ТоварыКПоступлениюИзменение", ТекстЗапросаТоварыКПоступлению(Запрос));
	СоответствиеЗаданий.Вставить("ДвиженияЗаказыНаПеремещениеИзменение", ТекстЗапросаЗаказыНаПеремещение(Запрос));
	СоответствиеЗаданий.Вставить("ДвиженияЗаказыНаСборкуИзменение", ТекстЗапросаЗаказыНаСборку(Запрос));
	СоответствиеЗаданий.Вставить("ДвиженияЗаказыНаВнутреннееПотреблениеИзменение", ТекстЗапросаЗаказыНаВнутреннееПотребление(Запрос));
	Если Не РаспределениеЗапасов.ДосчитыватьРегистрРегламентнымЗаданием() Тогда
		СоответствиеЗаданий.Вставить("СостоянияВнутреннихЗаказовИзменение",
			ТекстЗапросаСостоянияВнутреннихЗаказовИзменение(Запрос));
	КонецЕсли;
	Возврат СоответствиеЗаданий;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПараметрыАктуализацииСостоянийЗаказов() Экспорт
	
	Результат = Новый Структура("ПравилоОтбораЗаписей,ФункцияСравненияЗаписей,ФункцияСравненияЗаписейВоВременнуюТаблицу");
	
	Результат.ПравилоОтбораЗаписей =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РаспределениеЗапасов.ЗаказНаОтгрузку КАК ЗаказНаОтгрузку
		|ПОМЕСТИТЬ ТаблицаПереопределяемый
		|ИЗ
		|	ФильтрПереопределяемый КАК Товары
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаспределениеЗапасов КАК РаспределениеЗапасов
		|		ПО РаспределениеЗапасов.Номенклатура  = Товары.Номенклатура
		|		И РаспределениеЗапасов.Характеристика = Товары.Характеристика
		|		И РаспределениеЗапасов.Склад          = Товары.Склад
		|		И РаспределениеЗапасов.Назначение     = Товары.Назначение
		|		И РаспределениеЗапасов.Состояние В(
		|				ЗНАЧЕНИЕ(Перечисление.РаспределениеЗапасовСостояния.Обеспечить),
		|				ЗНАЧЕНИЕ(Перечисление.РаспределениеЗапасовСостояния.ОжидаетсяПоНеподтвержденномуЗаказу),
		|				ЗНАЧЕНИЕ(Перечисление.РаспределениеЗапасовСостояния.ОбеспеченКДате))
		|				
		|ГДЕ
		|	НЕ РаспределениеЗапасов.Номенклатура ЕСТЬ NULL
		|		И ТИПЗНАЧЕНИЯ(РаспределениеЗапасов.ЗаказНаОтгрузку) В(
		|			ТИП(Документ.ЗаказНаСборку),
		|			ТИП(Документ.ЗаказНаВнутреннееПотребление),
		|			ТИП(Документ.ЗаказНаПеремещение))
		|ИНДЕКСИРОВАТЬ ПО
		|	ЗаказНаОтгрузку";
		
	Результат.ФункцияСравненияЗаписейВоВременнуюТаблицу =
		"ВЫБРАТЬ
		|	ПередЗаписью.ЗаказНаОтгрузку КАК Заказ
		|ПОМЕСТИТЬ ИзменениеПереопределяемый
		|ИЗ
		|	ПередЗаписьюПереопределяемый КАК ПередЗаписью
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПриЗаписиПереопределяемый КАК ПриЗаписи
		|		ПО ПриЗаписи.ЗаказНаОтгрузку = ПередЗаписью.ЗаказНаОтгрузку
		|ГДЕ
		|		ПриЗаписи.ЗаказНаОтгрузку ЕСТЬ NULL
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ПриЗаписи.ЗаказНаОтгрузку КАК Заказ
		|ИЗ
		|	ПриЗаписиПереопределяемый КАК ПриЗаписи
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПередЗаписьюПереопределяемый КАК ПередЗаписью
		|		ПО ПередЗаписью.ЗаказНаОтгрузку = ПриЗаписи.ЗаказНаОтгрузку
		|ГДЕ
		|	ПередЗаписью.ЗаказНаОтгрузку ЕСТЬ NULL";
	
	Результат.ФункцияСравненияЗаписей = СтрЗаменить(Результат.ФункцияСравненияЗаписейВоВременнуюТаблицу,
		"ПОМЕСТИТЬ ИзменениеПереопределяемый", "");
	
Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТаблицаИзмененийСостоянийЗаказов(ТипДокумента, МассивЗаказов)
	
	МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТипДокумента);
	СтруктураПараметровДокумента = МенеджерДокумента.ПараметрыДляРасчетаСостояний();
	
	ВременныеТаблицыДокумента       = МенеджерДокумента.ВременныеТаблицыДокументаДляРасчетаСостояний();
	ВременнаяТаблицаОстаткиЗаказов  = СтруктураПараметровДокумента.МодульОстаткиЗаказов.ВременнаяТаблицаОстаткиЗаказов();
	
	ТекстыЗапроса = Новый СписокЗначений();
	ТекстыЗапроса.Добавить(ВременныеТаблицыДокумента.ТоварыДокумента,          "");
	ТекстыЗапроса.Добавить(ВременныеТаблицыДокумента.РеквизитыДокумента,       "");
	ТекстыЗапроса.Добавить(ВременнаяТаблицаОбеспечениеЗаказа(),                "");
	ТекстыЗапроса.Добавить(ВременнаяТаблицаОстаткиЗаказов,                     "");
	ТекстыЗапроса.Добавить(ВременнаяТаблицаОстаткиКОтгрузке(),                 "");
	ТекстыЗапроса.Добавить(ВременнаяТаблицаОстаткиКПоступлению(),              "");
	ТекстыЗапроса.Добавить(ВременнаяТаблицаРасхожденияНакладнаяОрдер(),        "");
	ТекстыЗапроса.Добавить(ВременнаяТаблицаОборотыКОтгрузкеСОрдерныхСкладов(), "");
	ТекстыЗапроса.Добавить(ВременнаяТаблицаЧастичноВНаличии(),                 "");
	ТекстыЗапроса.Добавить(ТекстЗапросаРасчетаСостояний(),                     "Таблица");
	
	Запрос = Новый Запрос();
	
	Запрос.УстановитьПараметр("КонтролироватьЗакрытиеЗаказа", СтруктураПараметровДокумента.КонтролироватьЗакрытиеЗаказа);
	Запрос.УстановитьПараметр("СтатусВПроцессеПоступления", СтруктураПараметровДокумента.СтатусВПроцессеПоступления);
	Запрос.УстановитьПараметр("СтатусВПроцессеОтгрузки", СтруктураПараметровДокумента.СтатусВПроцессеОтгрузки);
	Запрос.УстановитьПараметр("СтатусГотовКОтгрузке", СтруктураПараметровДокумента.СтатусГотовКОтгрузке);
	
	Запрос.УстановитьПараметр("МассивЗаказов", МассивЗаказов);
	Запрос.УстановитьПараметр("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("МенеджерСоздаетОрдера",
		Константы.РежимФормированияРасходныхОрдеров.Получить() = Перечисления.РежимыФормированияРасходныхОрдеров.Менеджером);
	
	Таблицы = ОбщегоНазначенияУТ.ВыгрузитьРезультатыЗапроса(Запрос, ТекстыЗапроса, , Истина);

	Возврат Таблицы.Таблица;

КонецФункции

Функция ТекстЗапросаРасчетаСостояний()
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.Ссылка                        КАК Заказ,
		|	Таблица.Состояние                     КАК Состояние,
		|	Таблица.ЕстьРасхожденияОрдерНакладная КАК ЕстьРасхожденияОрдерНакладная
		|ИЗ(
		|ВЫБРАТЬ
		|	ВтРеквизитыДокумента.Ссылка КАК Ссылка,
		|
		|	ВЫБОР КОГДА НЕ ВтРеквизитыДокумента.Проведен ТОГДА
		|
		|			ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.ПустаяСсылка)
		|
		|		КОГДА ВтРеквизитыДокумента.СтатусНаСогласовании ТОГДА
		|
		|			ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.ОжидаетсяСогласование)
		|
		|		КОГДА ВТОбеспечениеЗаказа.Ссылка ЕСТЬ NULL ТОГДА
		|
		|			ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.ПустаяСсылка)
		|
		|		КОГДА ВТОбеспечениеЗаказа.ЕстьКОбеспечению ТОГДА
		|
		|			ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.ГотовКОбеспечению)
		|
		|		КОГДА НЕ ВтЧастичноВНаличии.Ссылка ЕСТЬ NULL ТОГДА
		|
		|			ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.ОжидаетсяОбеспечение)
		|
		|		КОГДА НЕ ВтРеквизитыДокумента.СтатусКОтгрузке ИЛИ НЕ ВТОбеспечениеЗаказа.ВсеОтгрузить ТОГДА
		|
		|			&СтатусГотовКОтгрузке
		|
		|		КОГДА &МенеджерСоздаетОрдера И ВтОборотыКОтгрузке.Расход = 0 ТОГДА
		|
		|			ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.ГотовКОтгрузке)
		|
		|		КОГДА НЕ ВтОстаткиЗаказов.Распоряжение ЕСТЬ NULL ТОГДА
		|
		|			&СтатусВПроцессеОтгрузки
		|
		|		КОГДА НЕ ВтОстаткиКОтгрузке.Распоряжение ЕСТЬ NULL ТОГДА
		|
		|			&СтатусВПроцессеОтгрузки
		|
		|		КОГДА НЕ ВтОстаткиКПоступлению.Распоряжение ЕСТЬ NULL ТОГДА
		|
		|			&СтатусВПроцессеПоступления
		|
		|		КОГДА НЕ ВтРеквизитыДокумента.СтатусЗакрыт И &КонтролироватьЗакрытиеЗаказа ТОГДА
		|
		|			ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.ГотовКЗакрытию)
		|
		|		ИНАЧЕ
		|
		|			ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.Закрыт)
		|
		|	КОНЕЦ КАК Состояние,
		|	ВЫБОР КОГДА ВтРасхожденияНакладнаяОрдер.Распоряжение ЕСТЬ NULL ТОГДА
		|				ЛОЖЬ
		|			ИНАЧЕ
		|				ИСТИНА
		|		КОНЕЦ КАК ЕстьРасхожденияОрдерНакладная
		|
		|ИЗ
		|	ВтРеквизитыДокумента КАК ВтРеквизитыДокумента
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОбеспечениеЗаказа КАК ВТОбеспечениеЗаказа
		|		ПО ВТОбеспечениеЗаказа.Ссылка = ВтРеквизитыДокумента.Ссылка
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтЧастичноВНаличии КАК ВтЧастичноВНаличии
		|		ПО ВтЧастичноВНаличии.Ссылка = ВтРеквизитыДокумента.Ссылка
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтОборотыКОтгрузке КАК ВтОборотыКОтгрузке
		|		ПО ВтОборотыКОтгрузке.Распоряжение = ВтРеквизитыДокумента.Ссылка
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтОстаткиЗаказов КАК ВтОстаткиЗаказов
		|		ПО ВтОстаткиЗаказов.Распоряжение = ВтРеквизитыДокумента.Ссылка
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтОстаткиКОтгрузке КАК ВтОстаткиКОтгрузке
		|		ПО ВтОстаткиКОтгрузке.Распоряжение = ВтРеквизитыДокумента.Ссылка
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтОстаткиКПоступлению КАК ВтОстаткиКПоступлению
		|		ПО ВтОстаткиКПоступлению.Распоряжение = ВтРеквизитыДокумента.Ссылка
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтРасхожденияНакладнаяОрдер КАК ВтРасхожденияНакладнаяОрдер
		|		ПО ВтРасхожденияНакладнаяОрдер.Распоряжение = ВтРеквизитыДокумента.Ссылка) КАК Таблица";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ВременнаяТаблицаОбеспечениеЗаказа()
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.Ссылка КАК Ссылка,
		|	МАКСИМУМ(Таблица.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.НеТребуется)
		|		И Таблица.ЭтоТовар) КАК ЕстьКОбеспечению,
		|	МАКСИМУМ(Таблица.ВариантОбеспечения В(
		|			ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.КОбеспечению),
		|			ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.РезервироватьПоМереПоступления))) КАК ЕстьТребующиеРаспределенияЗапасов,
		|	МИНИМУМ(Таблица.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить)) КАК ВсеОтгрузить
		|ПОМЕСТИТЬ ВТОбеспечениеЗаказа
		|	ИЗ
		|		ВтТоварыДокумента КАК Таблица
		|СГРУППИРОВАТЬ ПО
		|	Таблица.Ссылка";
	
	Возврат ТекстЗапроса
	
КонецФункции

Функция ВременнаяТаблицаОстаткиКОтгрузке()
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.ДокументОтгрузки КАК Распоряжение,
		|	Таблица.КОтгрузкеОстаток КАК Количество
		|ПОМЕСТИТЬ ВтОстаткиКОтгрузке
		|ИЗ
		|	РегистрНакопления.ТоварыКОтгрузке.Остатки(, ДокументОтгрузки В (&МассивЗаказов)) КАК Таблица";
		
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ВременнаяТаблицаОстаткиКПоступлению()
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.ДокументПоступления КАК Распоряжение,
		|	Таблица.КОформлениюОрдеровОстаток КАК Количество
		|ПОМЕСТИТЬ ВтОстаткиКПоступлению
		|ИЗ
		|	РегистрНакопления.ТоварыКПоступлению.Остатки(, ДокументПоступления В (&МассивЗаказов)) КАК Таблица";
		
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ВременнаяТаблицаРасхожденияНакладнаяОрдер()
	
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Набор.Распоряжение КАК Распоряжение
		|ПОМЕСТИТЬ ВтРасхожденияНакладнаяОрдер
		|ИЗ(
		|	ВЫБРАТЬ
		|		Таблица.ДокументОтгрузки КАК Распоряжение,
		|
		|		Таблица.Номенклатура     КАК Номенклатура,
		|		Таблица.Характеристика   КАК Характеристика,
		|		Таблица.Склад            КАК Склад,
		|		Таблица.Назначение       КАК Назначение,
		|		Таблица.Серия            КАК Серия
		|
		|ИЗ
		|	РегистрНакопления.ТоварыКОтгрузке.ОстаткиИОбороты(,,,, ДокументОтгрузки В (&МассивЗаказов)) КАК Таблица
		|ГДЕ
		|	Таблица.КОформлениюРасход <> Таблица.КОтгрузкеРасход + Таблица.СобраноПриход
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		Таблица.ДокументПоступления КАК Распоряжение,
		|
		|		Таблица.Номенклатура     КАК Номенклатура,
		|		Таблица.Характеристика   КАК Характеристика,
		|		Таблица.Склад            КАК Склад,
		|		Таблица.Назначение       КАК Назначение,
		|		Таблица.Серия            КАК Серия
		|
		|ИЗ
		|	РегистрНакопления.ТоварыКПоступлению.Остатки(,ДокументПоступления В (&МассивЗаказов)) КАК Таблица
		|ГДЕ
		|	Таблица.КОформлениюПоступленийПоОрдерамОстаток <> 0
		|
		|) КАК Набор";
		
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ВременнаяТаблицаОборотыКОтгрузкеСОрдерныхСкладов()
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.ДокументОтгрузки  КАК Распоряжение,
		|	Таблица.КОтгрузкеПриход   КАК Приход,
		|	Таблица.КОтгрузкеРасход + Таблица.КСборкеПриход + Таблица.СобираетсяПриход + Таблица.СобраноПриход КАК Расход //все ордера
		|ПОМЕСТИТЬ ВтОборотыКОтгрузке
		|ИЗ
		|	РегистрНакопления.ТоварыКОтгрузке.ОстаткиИОбороты(,,,,
		|		ДокументОтгрузки В (&МассивЗаказов)
		|		И Склад В(
		|			ВЫБРАТЬ
		|				СпрСклады.Ссылка КАК Склад
		|			ИЗ
		|				Справочник.Склады КАК СпрСклады
		|			ГДЕ
		|				СпрСклады.ИспользоватьОрдернуюСхемуПриОтгрузке
		|				И СпрСклады.ДатаНачалаОрдернойСхемыПриОтгрузке <= &ТекущаяДата)) КАК Таблица";
	
	Возврат ТекстЗапроса
	
КонецФункции

Функция ВременнаяТаблицаЧастичноВНаличии()
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Заказы.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ВТЧастичноВНаличии
		|ИЗ
		|	ВТОбеспечениеЗаказа КАК Заказы
		|ГДЕ
		|	Заказы.ЕстьТребующиеРаспределенияЗапасов
		|	И (ИСТИНА В(
		|		ВЫБРАТЬ ПЕРВЫЕ 1
		|			ИСТИНА КАК ЕстьЗаписи
		|		ИЗ
		|			РегистрСведений.РаспределениеЗапасов КАК Сведения
		|		ГДЕ
		|			Сведения.ЗаказНаОтгрузку = Заказы.Ссылка
		|				И Сведения.Состояние В(
		|					ЗНАЧЕНИЕ(Перечисление.РаспределениеЗапасовСостояния.ОбеспеченКДате),
		|					ЗНАЧЕНИЕ(Перечисление.РаспределениеЗапасовСостояния.ОжидаетсяПоНеподтвержденномуЗаказу),
		|					ЗНАЧЕНИЕ(Перечисление.РаспределениеЗапасовСостояния.Обеспечить)))
		// документ не был проведен
		|		ИЛИ НЕ ИСТИНА В(
		|				ВЫБРАТЬ ПЕРВЫЕ 1
		|					ИСТИНА КАК ЕстьЗаписи
		|				ИЗ
		|					РегистрСведений.РаспределениеЗапасов КАК Сведения
		|				ГДЕ
		|					Сведения.ЗаказНаОтгрузку = Заказы.Ссылка))";
	
	Возврат ТекстЗапроса
	
КонецФункции

Процедура ЗаписатьСостояния(Таблица)
	
	Для Каждого СтрокаТаблицы Из Таблица Цикл
	
		Набор = РегистрыСведений.СостоянияВнутреннихЗаказов.СоздатьНаборЗаписей();
		Набор.Отбор.Заказ.Установить(СтрокаТаблицы.Заказ);
		
		Если Не СтрокаТаблицы.Состояние.Пустая() Тогда
			СтрокаНабора = Набор.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНабора, СтрокаТаблицы);
		КонецЕсли;
		
		Набор.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры

#Область СлужебныеМетодыФормированияСостояний

#Область ТекстыЗапросовПоКонтрольнымРегистрам

Функция ТекстЗапросаТоварыКОтгрузке(Запрос)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.ДокументОтгрузки КАК ОтражаемыйДокумент
	|ИЗ
	|	ДвиженияТоварыКОтгрузкеИзменение КАК Таблица
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(Таблица.ДокументОтгрузки) В (ТИП(Документ.ЗаказНаПеремещение),
	|		ТИП(Документ.ЗаказНаСборку),
	|		ТИП(Документ.ЗаказНаВнутреннееПотребление))
	|";
	
	СтруктураТекстовЗапросов = ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов(ТекстЗапроса);
	
	Возврат СтруктураТекстовЗапросов;
	
КонецФункции

Функция ТекстЗапросаТоварыКПоступлению(Запрос)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.ДокументПоступления КАК ОтражаемыйДокумент
	|ИЗ
	|	ТоварыКПоступлениюИзменение КАК Таблица
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(Таблица.ДокументПоступления) В (ТИП(Документ.ЗаказНаПеремещение),
	|		ТИП(Документ.ЗаказНаСборку),
	|		ТИП(Документ.ЗаказНаВнутреннееПотребление))
	|";
	
	СтруктураТекстовЗапросов = ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов(ТекстЗапроса);
	
	Возврат СтруктураТекстовЗапросов;
	
КонецФункции

Функция ТекстЗапросаЗаказыНаПеремещение(Запрос)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.ЗаказНаПеремещение КАК ОтражаемыйДокумент
	|ИЗ
	|	ДвиженияЗаказыНаПеремещениеИзменение КАК Таблица
	|";
	
	СтруктураТекстовЗапросов = ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов(ТекстЗапроса);
	
	Возврат СтруктураТекстовЗапросов;
	
КонецФункции

Функция ТекстЗапросаЗаказыНаСборку(Запрос)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.ЗаказНаСборку КАК ОтражаемыйДокумент
	|ИЗ
	|	ДвиженияЗаказыНаСборкуИзменение КАК Таблица
	|";
	
	СтруктураТекстовЗапросов = ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов(ТекстЗапроса);
	
	Возврат СтруктураТекстовЗапросов;
	
КонецФункции

Функция ТекстЗапросаЗаказыНаВнутреннееПотребление(Запрос)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.ЗаказНаВнутреннееПотребление КАК ОтражаемыйДокумент
	|ИЗ
	|	ДвиженияЗаказыНаВнутреннееПотреблениеИзменение КАК Таблица
	|";
	
	СтруктураТекстовЗапросов = ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов(ТекстЗапроса);
	
	Возврат СтруктураТекстовЗапросов;
	
КонецФункции

Функция ТекстЗапросаСостоянияВнутреннихЗаказовИзменение(Запрос)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.Заказ КАК ОтражаемыйДокумент
	|ИЗ
	|	СостоянияВнутреннихЗаказовИзменение КАК Таблица
	|";
	
	СтруктураТекстовЗапросов = ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов(ТекстЗапроса);
	
	Возврат СтруктураТекстовЗапросов;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецЕсли
