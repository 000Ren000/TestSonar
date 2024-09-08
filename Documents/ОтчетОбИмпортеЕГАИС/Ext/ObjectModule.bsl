﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УведомлениеОПланируемомИмпортеЕГАИС") Тогда
		ЗаполнитьНаОснованииУведомленияОПланируемомИмпорте(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ОтчетОбИмпортеЕГАИС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ИнтеграцияИС.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыНакопления.ОстаткиАлкогольнойПродукцииЕГАИС.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	ИнтеграцияИСПереопределяемый.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	ИнтеграцияИС.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ИнтеграцияИС.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ОтчетПроизводственнойЛинии Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДанныеОтчетаПроизводственнойЛинии");
		Если ШтрихкодыУпаковок.Количество() Тогда
			ИнтеграцияЕГАИС.ПроверитьЗаполнениеШтрихкодовУпаковок(ЭтотОбъект, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	ПроверитьЗаполнениеКрепость(Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Идентификатор) Тогда
		Идентификатор = ИнтеграцияЕГАИС.НовыйИдентификаторДокумента();
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияЕГАИС.СопоставитьАлкогольнуюПродукциюСНоменклатурой(ЭтотОбъект);
	
	ИнтеграцияЕГАИС.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИС.ЗаписатьСтатусДокументаЕГАИСПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование       = Неопределено;
	Идентификатор           = "";
	ИдентификаторЕГАИС      = "";
	ДатаРегистрацииДвижений = '00010101';
	
	Если Товары.Количество() > 0 Тогда
		Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "Справка2");
	КонецЕсли;
	
	ШтрихкодыУпаковок.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаЗаполнения

Процедура ЗаполнитьНаОснованииУведомленияОПланируемомИмпорте(ДанныеЗаполнения)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Таблица.Ссылка           КАК ДокументОснование,
	|	НЕ Таблица.Проведен      КАК ЕстьОшибкиПроведен,
	|	Таблица.Ответственный    КАК Ответственный,
	|	Таблица.ОрганизацияЕГАИС КАК ОрганизацияЕГАИС
	|ИЗ
	|	Документ.УведомлениеОПланируемомИмпортеЕГАИС КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокументы.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ОформленныеДокументыОтчетОбИмпортеЕГАИС
	|ИЗ
	|	Документ.ОтчетОбИмпортеЕГАИС КАК ТаблицаДокументы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|		ПО СтатусыДокументовЕГАИС.Документ = ТаблицаДокументы.Ссылка
	|ГДЕ
	|	ТаблицаДокументы.ДокументОснование = &ДокументОснование
	|	И ТаблицаДокументы.Ссылка <> &ЭтаСсылка
	|	И ТаблицаДокументы.Проведен
	|	И СтатусыДокументовЕГАИС.Статус НЕ В(&КонечныеСтатусыОтчетОбИмпортеЕГАИС)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабличнаяЧасть.Номенклатура             КАК Номенклатура,
	|	ТабличнаяЧасть.Характеристика           КАК Характеристика,
	|	ТабличнаяЧасть.Серия                    КАК Серия,
	|	ТабличнаяЧасть.АлкогольнаяПродукция     КАК АлкогольнаяПродукция,
	|	ТабличнаяЧасть.ИдентификаторУведомления КАК ИдентификаторУведомления,
	|	ТабличнаяЧасть.Количество               КАК План,
	|	0                                       КАК Факт
	|ПОМЕСТИТЬ ТоварыКОформлению
	|ИЗ
	|	Документ.УведомлениеОПланируемомИмпортеЕГАИС.Товары КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &ДокументОснование
	|	И ТабличнаяЧасть.ИдентификаторУведомления <> """"
	|	И ТабличнаяЧасть.СтатусОбработки = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиУведомленияОПланируемомИмпортеЕГАИС.ПроведенЕГАИС)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Оформлено.Номенклатура             КАК Номенклатура,
	|	Оформлено.Характеристика           КАК Характеристика,
	|	Оформлено.Серия                    КАК Серия,
	|	Оформлено.АлкогольнаяПродукция     КАК АлкогольнаяПродукция,
	|	Оформлено.ИдентификаторУведомления КАК ИдентификаторУведомления,
	|	0                                  КАК План,
	|	Оформлено.Количество               КАК Факт
	|ИЗ
	|	Документ.ОтчетОбИмпортеЕГАИС.Товары КАК Оформлено
	|ГДЕ
	|	Оформлено.Ссылка В (ВЫБРАТЬ Т.Ссылка ИЗ ОформленныеДокументыОтчетОбИмпортеЕГАИС КАК Т)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыКОформлению.Номенклатура                         КАК Номенклатура,
	|	ТоварыКОформлению.Характеристика                       КАК Характеристика,
	|	ТоварыКОформлению.Серия                                КАК Серия,
	|	ТоварыКОформлению.АлкогольнаяПродукция                 КАК АлкогольнаяПродукция,
	|	ТоварыКОформлению.АлкогольнаяПродукция.Крепость        КАК Крепость,
	|	ТоварыКОформлению.ИдентификаторУведомления             КАК ИдентификаторУведомления,
	|	СУММА(ТоварыКОформлению.План - ТоварыКОформлению.Факт) КАК Количество,
	|	СУММА(ТоварыКОформлению.План - ТоварыКОформлению.Факт) КАК КоличествоУпаковок
	|ИЗ
	|	ТоварыКОформлению КАК ТоварыКОформлению
	|СГРУППИРОВАТЬ ПО
	|	ТоварыКОформлению.Номенклатура,
	|	ТоварыКОформлению.Характеристика,
	|	ТоварыКОформлению.Серия,
	|	ТоварыКОформлению.АлкогольнаяПродукция,
	|	ТоварыКОформлению.АлкогольнаяПродукция.Крепость,
	|	ТоварыКОформлению.ИдентификаторУведомления
	|ИМЕЮЩИЕ
	|	СУММА(ТоварыКОформлению.План - ТоварыКОформлению.Факт) > 0
	|";
	
	Запрос.УстановитьПараметр("ЭтаСсылка", Ссылка);
	Запрос.УстановитьПараметр("ДокументОснование", ДанныеЗаполнения);
	Запрос.УстановитьПараметр("КонечныеСтатусыОтчетОбИмпортеЕГАИС", Документы.ОтчетОбИмпортеЕГАИС.КонечныеСтатусы());
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	РеквизитыШапки = РезультатЗапроса[0].Выбрать();
	РеквизитыШапки.Следующий();
	
	ЭтоПерезаполнение = ЗначениеЗаполнено(Ссылка);
	
	Если Не ЭтоПерезаполнение Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыШапки);
		
	КонецЕсли;
	
	Товары.Очистить();
	ШтрихкодыУпаковок.Очистить();
	ДанныеОтчетаПроизводственнойЛинии.Очистить();
	
	Если Не ОтчетПроизводственнойЛинии Тогда
		ИнтеграцияЕГАИС.ЗаполнитьТабличнуюЧастьТовары(ЭтотОбъект, РезультатЗапроса[РезультатЗапроса.Количество() - 1], ДанныеЗаполнения, Истина);
	Иначе
		Выборка = РезультатЗапроса[РезультатЗапроса.Количество() - 1].Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(Товары.Добавить(), Выборка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Процедура ПроверитьЗаполнениеКрепость(Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов)
	
	Для Каждого СтрокаТовары Из Товары Цикл
		Если Не ЗначениеЗаполнено(СтрокаТовары.Крепость)
				И Не ЗначениеЗаполнено(СтрокаТовары.КрепостьДо) Тогда
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'В строке %1 табличной части Товары не заполнено поле ""Крепость""'"),
				СтрокаТовары.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
					"Товары", СтрокаТовары.НомерСтроки, "Крепость"),,
				Отказ);
		КонецЕсли;
	КонецЦикла;
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Крепость");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КрепостьОт");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КрепостьДо");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли