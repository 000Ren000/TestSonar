﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет таблицу реквизитов, зависимых от хозяйственной операции
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - хозяйственная операция соглашения
//	МассивВсехРеквизитов - Массив - реквизиты, которые не зависят от хозяйственной операции
//	МассивРеквизитовОперации - Массив - реквизиты, которые зависят от хозяйственной операции.
//
Процедура ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(ХозяйственнаяОперация, МассивВсехРеквизитов, МассивРеквизитовОперации) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("СпособРасчетаВознаграждения");
	МассивВсехРеквизитов.Добавить("ПроцентВознаграждения");
	МассивВсехРеквизитов.Добавить("УдержатьВознаграждение");
	МассивВсехРеквизитов.Добавить("ПроцентРучнойСкидки");
	МассивВсехРеквизитов.Добавить("ПроцентРучнойНаценки");
	
	МассивРеквизитовОперации = Новый Массив;
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию Тогда
		МассивРеквизитовОперации.Добавить("СпособРасчетаВознаграждения");
		МассивРеквизитовОперации.Добавить("ПроцентВознаграждения");
		МассивРеквизитовОперации.Добавить("УдержатьВознаграждение");
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОказаниеАгентскихУслуг Тогда
		МассивРеквизитовОперации.Добавить("СпособРасчетаВознаграждения");
		МассивРеквизитовОперации.Добавить("ПроцентВознаграждения");
		МассивРеквизитовОперации.Добавить("УдержатьВознаграждение");
		МассивРеквизитовОперации.Добавить("ТипыУслуг");
		МассивРеквизитовОперации.Добавить("АгентскиеУслуги");
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту 
			ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС Тогда
		МассивРеквизитовОперации.Добавить("ПроцентРучнойСкидки");
		МассивРеквизитовОперации.Добавить("ПроцентРучнойНаценки");
	Иначе
		МассивРеквизитовОперации.Добавить("ПроцентРучнойСкидки");
		МассивРеквизитовОперации.Добавить("ПроцентРучнойНаценки");
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает статус соглашений с поставщиками
//
// Параметры:
//	Соглашения - Массив - массив ссылок на соглашения с поставщиками
//	Статус     - ПеречислениеСсылка.СтатусыСоглашенийСПоставщиками - статус, который будет установлен у соглашений.
//
// Возвращаемое значение:
//	Число - количество обработанных строк.
//
Функция УстановитьСтатус(Знач Соглашения, Знач Статус) Экспорт
	
	МассивСсылок = Новый Массив();
	КоличествоОбработанных = 0;
	
	Для Каждого Соглашение Из Соглашения Цикл
	
		Если ТипЗнч(Соглашение) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		МассивСсылок.Добавить(Соглашение);
		
	КонецЦикла;
	
	Если МассивСсылок = 0 Тогда
		Возврат КоличествоОбработанных;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СоглашениеСПоставщиком.Ссылка КАК Ссылка,
	|	СоглашениеСПоставщиком.ПометкаУдаления КАК ПометкаУдаления,
	|	ВЫБОР
	|		КОГДА СоглашениеСПоставщиком.Статус = &Статус
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СтатусСовпадает
	|ИЗ
	|	Справочник.СоглашенияСПоставщиками КАК СоглашениеСПоставщиком
	|ГДЕ
	|	СоглашениеСПоставщиком.Ссылка В(&МассивСсылок)");
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.УстановитьПараметр("Статус", Статус);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ПометкаУдаления Тогда
			
			ТекстОшибки = НСтр("ru='Соглашение %Соглашение% помечено на удаление. Невозможно изменить статус'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%", Выборка.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
			Продолжить;
			
		КонецЕсли;
		
		Если Выборка.СтатусСовпадает Тогда
			
			ТекстОшибки = НСтр("ru='Соглашению %Соглашение% уже присвоен статус ""%Статус%""'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%", Выборка.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%", Статус);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
			Продолжить;
			
		КонецЕсли;
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
		Исключение
			
			ТекстОшибки = НСтр("ru='Не удалось заблокировать %Соглашение%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%", Выборка.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
			
		КонецПопытки;
		
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.Статус = Статус;
		
		Если Статус = Перечисления.СтатусыСоглашенийСКлиентами.НеСогласовано Тогда
			Если Объект.Согласован Тогда
				Объект.Согласован = Ложь;
			КонецЕсли;
		КонецЕсли;
			
		Если Не Объект.ПроверитьЗаполнение() Тогда
			Продолжить;
		КонецЕсли;
			
		Попытка
			
			Объект.Записать();
			КоличествоОбработанных = КоличествоОбработанных + 1;
			
		Исключение
			
			ТекстОшибки = НСтр("ru='Не удалось записать %Соглашение%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%", Выборка.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
			
		КонецПопытки
		
	КонецЦикла;
	
	Возврат КоличествоОбработанных;

КонецФункции

// Возвращает признак использования как агрегирующей сущности в товарах к поступлению.
//
// Параметры:
//  ВариантПриемкиТоваров - ПеречислениеСсылка.ВариантыПриемкиТоваров - ссылка на вариант приемки.
//
// Возвращаемое значение:
//  Булево - используется или нет соглашение при приемке.
//
Функция СоглашениеИспользуетсяПриПриемке(Знач ВариантПриемкиТоваров) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ВариантПриемкиТоваров) Тогда
		ВариантПриемкиТоваров = Константы.ВариантПриемкиТоваров.Получить();
	КонецЕсли;
	
	Результат = Ложь;
	Если ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.НеРазделенаПоЗаказамИНакладным
		Или ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.МожетПроисходитьБезЗаказовИНакладных 
		ИЛИ ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.НеРазделенаПоНакладным Тогда 

		Результат = Истина;

	КонецЕсли;

	Возврат Результат;

КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

// Создает соглашение по умолчанию.
//
// Параметры:
//  Параметры - Структура - структура заполнения.
//
// Возвращаемое значение:
//  СправочникСсылка.СоглашенияСПоставщиками - ссылка на созданное соглашение.
//
Функция СоздатьСоглашениеПоУмолчанию(Знач Параметры) Экспорт
	
	Соглашение = Справочники.СоглашенияСПоставщиками.СоздатьЭлемент();
	Соглашение.Заполнить(Неопределено);
	ЗаполнитьЗначенияСвойств(Соглашение, Параметры);
	Соглашение.Дата = ТекущаяДатаСеанса();
	Соглашение.Статус = Перечисления.СтатусыСоглашенийСПоставщиками.Действует;
	
	Если НЕ ЗначениеЗаполнено(Соглашение.Наименование) Тогда
		Соглашение.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Условия закупок с %1'"), Соглашение.Партнер);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Соглашение.ВариантПриемкиТоваров) ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьПоступлениеПоНесколькимЗаказам") Тогда
		Соглашение.ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.НеРазделенаПоЗаказамИНакладным;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Соглашение.ОплатаВВалюте) Тогда
		Соглашение.ОплатаВВалюте = Ложь;
	КонецЕсли;
	
	Соглашение.Записать();
	
	Возврат Соглашение.Ссылка
	
КонецФункции 

// Функция возвращает текст запроса для определения реквизитов доставки.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстЗапросаРеквизитыДоставки() Экспорт
		
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Шапка.Номер									КАК Номер,
	|	ИСТИНА										КАК Проведен,
	|	Шапка.Ссылка								КАК Ссылка,
	|	Шапка.Дата									КАК Дата,
	|	Шапка.Партнер								КАК ПолучательОтправитель,
	|	Шапка.ПеревозчикПартнер						КАК Перевозчик,
	|	ВЫБОР
	|		КОГДА Шапка.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчика)
	|				И НЕ &ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.Самовывоз)
	|		ИНАЧЕ Шапка.СпособДоставки
	|	КОНЕЦ										КАК СпособДоставки,
	|	Шапка.ЗонаДоставки							КАК Зона,
	|	ВЫБОР
	|		КОГДА Шапка.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчикаПоАдресу)
	|			ТОГДА Шапка.АдресДоставкиПеревозчика
	|		ИНАЧЕ Шапка.АдресДоставки
	|	КОНЕЦ										КАК Адрес,
	|	ВЫБОР
	|		КОГДА Шапка.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчикаПоАдресу)
	|			ТОГДА Шапка.АдресДоставкиПеревозчикаЗначенияПолей
	|		ИНАЧЕ Шапка.АдресДоставкиЗначенияПолей
	|	КОНЕЦ										КАК АдресЗначенияПолей,
	|	Шапка.ВремяДоставкиС						КАК ВремяС,
	|	Шапка.ВремяДоставкиПо						КАК ВремяПо,
	|	Шапка.ДополнительнаяИнформацияПоДоставке	КАК ДополнительнаяИнформация,
	|	Шапка.Склад									КАК Склад,
	|	ЛОЖЬ										КАК ДоставитьПолностью,
	|	ЛОЖЬ 										КАК ОсобыеУсловияПеревозки,
	|	""""										КАК ОсобыеУсловияПеревозкиОписание,
	|	ЛОЖЬ										КАК РазбиватьРасходныеОрдераПоРаспоряжениям	
	|ИЗ
	|	Справочник.СоглашенияСПоставщиками КАК Шапка
	|ГДЕ
	|	Шапка.Ссылка В(&Ссылки)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Функция возвращает текст запроса получения товаров к доставке по распоряжению
//
// Возвращаемое значение:
//  Строка - текст запроса
//
Функция ТекстЗапросаТоварыКДоставке() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТоварыКПоступлениюОстатки.ДокументПоступления КАК Ссылка,
	|	ТоварыКПоступлениюОстатки.Номенклатура КАК Номенклатура,
	|	ТоварыКПоступлениюОстатки.Характеристика КАК Характеристика,
	|	ТоварыКПоступлениюОстатки.Назначение КАК Назначение,
	|	ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) КАК Серия,
	|	ТоварыКПоступлениюОстатки.Склад КАК Склад,
	|	ТоварыКПоступлениюОстатки.КОформлениюОрдеровОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.ТоварыКПоступлению.Остатки(, ДокументПоступления В (&Ссылки)) КАК ТоварыКПоступлениюОстатки";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Добавляет команду создания справочника "Соглашение с поставщиками".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  Неопределено, СтрокаТаблицыЗначений - Добавить команду создать на основании
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	МетаданныеОбъекта =  Метаданные.Справочники.СоглашенияСПоставщиками;
	
	Если ПравоДоступа("Добавление",МетаданныеОбъекта) И ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСПоставщиками") Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = МетаданныеОбъекта.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(МетаданныеОбъекта);
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Формирует описание реквизитов объекта, заполняемых по статистике их использования.
//
// Параметры:
//  ОписаниеРеквизитов - Структура - описание реквизитов, для которых необходимо получить значения по статистике
//
//
Процедура ЗадатьОписаниеЗаполняемыхРеквизитовПоСтатистике(ОписаниеРеквизитов) Экспорт
	
	Параметры = ЗаполнениеОбъектовПоСтатистике.ПараметрыЗаполняемыхРеквизитов();
	Параметры.РазрезыСбораСтатистики.ИспользоватьВсегда = "Менеджер";
	ЗаполнениеОбъектовПоСтатистике.ДобавитьОписаниеЗаполняемыхРеквизитов(ОписаниеРеквизитов,
		"ИспользуютсяДоговорыКонтрагентов,ПорядокРасчетов", Параметры);
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Партнер)
	|	И ЗначениеРазрешено(Склад, ПустаяСсылка КАК Истина)
	|	И ЗначениеРазрешено(Организация, ПустаяСсылка КАК Истина)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Партнер       = Справочники.Партнеры.ПустаяСсылка();
	ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПустаяСсылка();
	ДатаДокумента = ТекущаяДатаСеанса();
	СтрокаПоиска  = "";
	ИспользуютсяДоговорыКонтрагентов = Неопределено;
	
	Если Параметры.Отбор.Свойство("Партнер") Тогда
		Партнер = Параметры.Отбор.Партнер;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Партнер) Тогда
		Возврат;
	КонецЕсли;
		
	Если Параметры.Отбор.Свойство("Дата") Тогда
		ДатаДокумента = Параметры.Отбор.Дата;
	КонецЕсли;
	
	Параметры.Свойство("СтрокаПоиска",СтрокаПоиска);
	
	ТекстЗапроса = "	
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 51
		|	СправочникСоглашениеСПоставщиком.Ссылка       КАК Ссылка,
		|	СправочникСоглашениеСПоставщиком.Наименование КАК Наименование,
		|	СправочникСоглашениеСПоставщиком.Номер        КАК Номер,
		|	СправочникСоглашениеСПоставщиком.Дата         КАК Дата,
		|	ВЫБОР
		|		КОГДА
		|			СправочникСоглашениеСПоставщиком.ПометкаУдаления
		|		ТОГДА
		|			0
		|		КОГДА
		|			СправочникСоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
		|		ТОГДА
		|			0
		|		КОГДА
		|			СправочникСоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.НеСогласовано)
		|		ТОГДА
		|			1
		|	КОНЕЦ КАК ИндексКартинки,
		|
		|	ВЫБОР
		|		КОГДА
		|			СправочникСоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
		|			И ((СправочникСоглашениеСПоставщиком.ДатаНачалаДействия <> ДАТАВРЕМЯ(1,1,1) И
		|			СправочникСоглашениеСПоставщиком.ДатаНачалаДействия > &ДатаДокумента))
		|		ТОГДА
		|			ИСТИНА
		|		ИНАЧЕ
		|			ЛОЖЬ
		|	КОНЕЦ КАК СрокДействияНеНаступил,
		|
		|	ВЫБОР
		|		КОГДА
		|			СправочникСоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
		|			И ((СправочникСоглашениеСПоставщиком.ДатаОкончанияДействия <> ДАТАВРЕМЯ(1,1,1) И
		|			СправочникСоглашениеСПоставщиком.ДатаОкончанияДействия < &ДатаДокумента))
		|		ТОГДА
		|			ИСТИНА
		|		ИНАЧЕ
		|			ЛОЖЬ
		|	КОНЕЦ КАК СрокДействияИстек
		|
		|ИЗ
		|	Справочник.СоглашенияСПоставщиками КАК СправочникСоглашениеСПоставщиком
		|ГДЕ
		|	СправочникСоглашениеСПоставщиком.Партнер = &Партнер
		|	И СправочникСоглашениеСПоставщиком.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Закрыто)
		|	И (СправочникСоглашениеСПоставщиком.Наименование ПОДОБНО &СтрокаПоиска
		|	ИЛИ СправочникСоглашениеСПоставщиком.Номер ПОДОБНО &СтрокаПоиска)
		|";
	
	
	Если Параметры.Отбор.Свойство("ХозяйственнаяОперация", ХозяйственнаяОперация) Тогда
		Если ТипЗнч(ХозяйственнаяОперация) = Тип("ПеречислениеСсылка.ХозяйственныеОперации") Тогда
			ТекстЗапроса = ТекстЗапроса + "
				|	И СправочникСоглашениеСПоставщиком.ХозяйственнаяОперация = &ХозяйственнаяОперация";
		ИначеЕсли ТипЗнч(ХозяйственнаяОперация) = Тип("Массив") Тогда 
			ТекстЗапроса = ТекстЗапроса + "
				|	И СправочникСоглашениеСПоставщиком.ХозяйственнаяОперация В(&ХозяйственнаяОперация)";
		КонецЕсли;
	КонецЕсли;
	Если Параметры.Отбор.Свойство("ИспользуютсяДоговорыКонтрагентов", ИспользуютсяДоговорыКонтрагентов) Тогда
		Если ИспользуютсяДоговорыКонтрагентов <> Неопределено Тогда 
			ТекстЗапроса = ТекстЗапроса + "
					|	И СправочникСоглашениеСПоставщиком.ИспользуютсяДоговорыКонтрагентов = &ИспользуютсяДоговорыКонтрагентов";
		КонецЕсли;
	КонецЕсли;
	 
	
	ТекстЗапроса = ТекстЗапроса + "
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачалаДействия ВОЗР,
		|	ДатаОкончанияДействия ВОЗР
		|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Партнер",       			Партнер);
	Запрос.УстановитьПараметр("ДатаДокумента", 			НачалоДня(ДатаДокумента));
	Запрос.УстановитьПараметр("СтрокаПоиска",  			СтрокаПоиска + "%");
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", 	ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("ИспользуютсяДоговорыКонтрагентов", ИспользуютсяДоговорыКонтрагентов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ДанныеВыбора = Новый СписокЗначений();
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если ЗначениеЗаполнено(Выборка.Наименование) И
				ЗначениеЗаполнено(Выборка.Дата) И
				ЗначениеЗаполнено(Выборка.Номер) Тогда
				
				Представление = НСтр("ru='%Наименование% (%Номер% от %Дата%)'");
				Представление = СтрЗаменить(Представление,"%Наименование%", Выборка.Наименование);
				Представление = СтрЗаменить(Представление,"%Номер%",        Выборка.Номер);
				Представление = СтрЗаменить(Представление,"%Дата%",         Формат(Выборка.Дата, "ДЛФ=D"));
				
			ИначеЕсли ЗначениеЗаполнено(Выборка.Наименование) И
				ЗначениеЗаполнено(Выборка.Дата) Тогда
				
				Представление = НСтр("ru='%Наименование% (от %Дата%)'");
				Представление = СтрЗаменить(Представление,"%Наименование%", Выборка.Наименование);
				Представление = СтрЗаменить(Представление,"%Дата%",         Формат(Выборка.Дата, "ДЛФ=D"));
				
			ИначеЕсли ЗначениеЗаполнено(Выборка.Наименование) И
				ЗначениеЗаполнено(Выборка.Номер) Тогда
				
				Представление = НСтр("ru='%Наименование% (%Номер%)'");
				Представление = СтрЗаменить(Представление,"%Наименование%", Выборка.Наименование);
				Представление = СтрЗаменить(Представление,"%Номер%",        Выборка.Номер);
				
			Иначе
				
				Представление = НСтр("ru='%Наименование%'");
				Представление = СтрЗаменить(Представление,"%Наименование%", Выборка.Наименование);
				
			КонецЕсли;
			
			Структура = Новый Структура();
			Структура.Вставить("Значение", Выборка.Ссылка);
			
			Если Выборка.СрокДействияНеНаступил Тогда
				Структура.Вставить("Предупреждение", НСтр("ru='У соглашения не наступил срок действия.'"));
			ИначеЕсли Выборка.СрокДействияИстек Тогда
				Структура.Вставить("Предупреждение", НСтр("ru='У соглашения истек срок действия.'"));
			КонецЕсли;
			
			Если Выборка.ИндексКартинки = 0 Тогда
				Картинка = БиблиотекаКартинок.СоглашениеСПоставщиком;
			Иначе
				Картинка = БиблиотекаКартинок.СоглашениеСПоставщикомНеСогласовано;
			КонецЕсли;
				
			ДанныеВыбора.Добавить(
				Структура,
				Представление,
				,
				Картинка);
			
		КонецЦикла;
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область СозданиеНаОсновании

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	НоваяКоманда = Справочники.ДоговорыКонтрагентов.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если НоваяКоманда <> Неопределено Тогда
		НоваяКоманда.ФункциональныеОпции = "ИспользоватьДоговорыСПоставщиками";
	КонецЕсли;
	
	НоваяКоманда = БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если НоваяКоманда <> Неопределено Тогда
		НоваяКоманда.РежимЗаписи = "";
	КонецЕсли;
	
	НоваяКоманда = Документы.ЗаказПоставщику.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если НоваяКоманда <> Неопределено Тогда
		НоваяКоманда.РежимЗаписи = "";
	КонецЕсли;
	
	НоваяКоманда = Документы.ПриемкаТоваровНаХранение.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если НоваяКоманда <> Неопределено Тогда
		НоваяКоманда.РежимЗаписи = "";
	КонецЕсли;
	
	НоваяКоманда = Документы.ПриобретениеТоваровУслуг.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если НоваяКоманда <> Неопределено Тогда
		НоваяКоманда.РежимЗаписи = "";
	КонецЕсли;
	
	НоваяКоманда = Документы.РегистрацияЦенНоменклатурыПоставщика.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если НоваяКоманда <> Неопределено Тогда
		НоваяКоманда.РежимЗаписи = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ТекущиеДела

// Заполняет список текущих дел пользователя.
// Параметры: 
//     ТекущиеДела - см. ТекущиеДелаСервер.ТекущиеДела
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ИмяФормы = "Справочник.СоглашенияСПоставщиками.Форма.ФормаСписка";
	
	ОбщиеПараметрыЗапросов = ТекущиеДелаСлужебный.ОбщиеПараметрыЗапросов();
	
	// Определим доступны ли текущему пользователю показатели группы
	Доступность =
		(ОбщиеПараметрыЗапросов.ЭтоПолноправныйПользователь
			Или ПравоДоступа("Просмотр", Метаданные.Справочники.СоглашенияСПоставщиками))
		И ПравоДоступа("Изменение", Метаданные.Справочники.СоглашенияСПоставщиками)
	    И ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСПоставщиками");
		
	Если НЕ Доступность Тогда
		Возврат;
	КонецЕсли;
	
	// Расчет показателей
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|			КОГДА СоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.НеСогласовано)
	|				ТОГДА СоглашениеСПоставщиком.Ссылка
	|		КОНЕЦ) КАК СоглашенияСПоставщикамиНаСогласовании,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|			КОГДА СоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.НеСогласовано)
	|					И СоглашениеСПоставщиком.ДатаНачалаДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|					И СоглашениеСПоставщиком.ДатаНачалаДействия < &ДатаАктуальности
	|				ТОГДА СоглашениеСПоставщиком.Ссылка
	|			КОГДА СоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
	|					И СоглашениеСПоставщиком.ДатаОкончанияДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|					И СоглашениеСПоставщиком.ДатаОкончанияДействия < &ДатаАктуальности
	|				ТОГДА СоглашениеСПоставщиком.Ссылка
	|			КОГДА СоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
	|					И СоглашениеСПоставщиком.ДатаНачалаДействия <> ДАТАВРЕМЯ(1,1,1) И
	|					СоглашениеСПоставщиком.ДатаНачалаДействия > &ДатаАктуальности
	|				ТОГДА СоглашениеСПоставщиком.Ссылка
	|			ИНАЧЕ NULL
	|		КОНЕЦ) КАК СоглашенияСПоставщикамиПросроченные
	|ИЗ
	|	Справочник.СоглашенияСПоставщиками КАК СоглашениеСПоставщиком
	|ГДЕ
	|	СоглашениеСПоставщиком.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Закрыто)
	|	И СоглашениеСПоставщиком.Менеджер = &Пользователь
	|	И (НЕ СоглашениеСПоставщиком.ПометкаУдаления)";
	
	Результат = ТекущиеДелаСлужебный.ЧисловыеПоказателиТекущихДел(Запрос, ОбщиеПараметрыЗапросов);
	
	// Заполнение дел.
	// СоглашенияСПоставщиками
	ДелоРодитель = ТекущиеДела.Добавить();
	ДелоРодитель.Идентификатор  = "СоглашенияСПоставщиками";
	ДелоРодитель.Представление  = НСтр("ru = 'Соглашения с поставщиками'");
	ДелоРодитель.Владелец       = Метаданные.Подсистемы.Закупки;
	
	// СоглашенияСПоставщикамиНаСогласовании
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Состояние", Перечисления.СостоянияСоглашенийСПоставщиками.ОжидаетсяСогласование);
	ПараметрыОтбора.Вставить("Актуальность", "");
	ПараметрыОтбора.Вставить("ДатаСобытия", ОбщиеПараметрыЗапросов.ПустаяДата);
	ПараметрыОтбора.Вставить("Менеджер", ОбщиеПараметрыЗапросов.Пользователь);
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "СоглашенияСПоставщикамиНаСогласовании";
	Дело.ЕстьДела       = Результат.СоглашенияСПоставщикамиНаСогласовании > 0;
	Дело.Представление  = НСтр("ru = 'Соглашения на согласовании'");
	Дело.Количество     = Результат.СоглашенияСПоставщикамиНаСогласовании;
	Дело.Важное         = Ложь;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора", ПараметрыОтбора);
	Дело.Владелец       = "СоглашенияСПоставщиками";
	
	// СоглашенияСПоставщикамиПросроченные
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Состояние", Неопределено);
	ПараметрыОтбора.Вставить("Актуальность", "Просроченные");
	ПараметрыОтбора.Вставить("ДатаСобытия", ОбщиеПараметрыЗапросов.ПустаяДата);
	ПараметрыОтбора.Вставить("Менеджер", ОбщиеПараметрыЗапросов.Пользователь);
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "СоглашенияСПоставщикамиПросроченные";
	Дело.ЕстьДела       = Результат.СоглашенияСПоставщикамиПросроченные > 0;
	Дело.Представление  = НСтр("ru = 'Просроченные соглашения'");
	Дело.Количество     = Результат.СоглашенияСПоставщикамиПросроченные;
	Дело.Важное         = Истина;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора", ПараметрыОтбора);
	Дело.Владелец       = "СоглашенияСПоставщиками";
	
	Если Результат.СоглашенияСПоставщикамиНаСогласовании > 0
		Или Результат.СоглашенияСПоставщикамиПросроченные > 0 Тогда
		ДелоРодитель.ЕстьДела = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ШаблоныСообщений

// Вызывается при подготовке шаблонов сообщений и позволяет переопределить список реквизитов и вложений.
//
// Параметры:
//  Реквизиты               - ДеревоЗначений - список реквизитов шаблона:
//         * Имя            - Строка - Уникальное имя общего реквизита.
//         * Представление  - Строка - Представление общего реквизита.
//         * Тип            - Тип    - Тип реквизита. По умолчанию строка.
//         * Формат         - Строка - Формат вывода значения для чисел, дат, строк и булевых значений.
//  Вложения                - ТаблицаЗначений - печатные формы и вложения:
//         * Имя            - Строка - Уникальное имя вложения.
//         * Представление  - Строка - Представление варианта.
//         * ТипФайла       - Строка - Тип вложения, который соответствует расширению файла: "pdf", "png", "jpg", mxl"
//                                      и др.
//  ДополнительныеПараметры - Структура - дополнительные сведения о шаблоне сообщений.
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Вызывается в момент создания сообщений по шаблону для заполнения значений реквизитов и вложений.
//
// Параметры:
//  Сообщение - Структура - структура с ключами:
//    * ЗначенияРеквизитов - Соответствие из КлючИЗначение- список используемых в шаблоне реквизитов:
//      * Ключ     - Строка - имя реквизита в шаблоне;
//      * Значение - Строка - значение заполнения в шаблоне.
//    * ЗначенияОбщихРеквизитов - Соответствие из КлючИЗначение - список используемых в шаблоне общих реквизитов:
//      * Ключ     - Строка - имя реквизита в шаблоне;
//      * Значение - Строка - значение заполнения в шаблоне.
//    * Вложения - Соответствие из КлючИЗначение - значения реквизитов
//      * Ключ     - Строка - имя вложения в шаблоне;
//      * Значение - ДвоичныеДанные, Строка - двоичные данные или адрес во временном хранилище вложения.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//  ДополнительныеПараметры - Структура -  Дополнительная информация о шаблоне сообщения.
//
Процедура ПриФормированииСообщения(Сообщение, ПредметСообщения, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Заполняет список получателей SMS при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиSMS - ТаблицаЗначений - список получается SMS:
//     * НомерТелефона - Строка - номер телефона, куда будет отправлено сообщение SMS.
//     * Представление - Строка - представление получателя сообщения SMS.
//     * Контакт       - СправочникСсылка - контакт, которому принадлежит номер телефона.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//
Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, ПредметСообщения) Экспорт
	
КонецПроцедуры

// Заполняет список получателей письма при отправки сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиПисьма - ТаблицаЗначений - список получается письма:
//     * Адрес           - Строка - адрес электронной почты получателя.
//     * Представление   - Строка - представление получается письма.
//     * ВариантОтправки - Строка - Варианты отправки письма: "Кому", "Копия", "СкрытаяКопия", "ОбратныйАдреса";
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, ПредметСообщения) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#КонецЕсли
