﻿#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Ссылка");
	Поля.Добавить("Наименование");
	Поля.Добавить("ТребуетсяЗагрузка");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Если Данные.ТребуетсяЗагрузка = Истина Тогда
		СтандартнаяОбработка = Ложь;
		Представление = НСтр("ru = '<не загружено>'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает ссылку на хозяйствующий субъект и значение реквизита по идентификатору
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторИС - идентификатор
// 
// Возвращаемое значение:
//  Структура - результат поиска с полями:
//   * Ссылка                   - Неопределено,СправочникСсылка.ХозяйствующиеСубъектыВЕТИС - хозяйствующий субъект
//   * СоответствуетОрганизации - Булево - значение реквизита
//
Функция ХозяйствующийСубъектСоответствуетОрганизации(Идентификатор) Экспорт
	
	Результат = Новый Структура("Ссылка, СоответствуетОрганизации", Неопределено, Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Субъект.Ссылка КАК Ссылка,
	|	Субъект.СоответствуетОрганизации КАК СоответствуетОрганизации
	|ИЗ
	|	Справочник.ХозяйствующиеСубъектыВЕТИС КАК Субъект
	|ГДЕ
	|	Субъект.Идентификатор = &Идентификатор
	|	И НЕ Субъект.ПометкаУдаления
	|;";
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции

// Функция - Предприятия хозяйствующего субъекта
//
// Параметры:
//  ХозяйствующийСубъектСсылка - СправочникСсылка.ХозяйствующиеСубъектыВЕТИС - хозяйствующий субъект
// 
// Возвращаемое значение:
//  Массив Из СправочникСсылка.ПредприятияВЕТИС - массив предприятий хозяйствующего субъекта
//
Функция ПредприятияХозяйствующегоСубъекта(ХозяйствующийСубъектСсылка) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",ХозяйствующийСубъектСсылка);
	Запрос.Текст = "ВЫБРАТЬ
	|	Субъект.Предприятие КАК Предприятие
	|ИЗ
	|	Справочник.ХозяйствующиеСубъектыВЕТИС.Предприятия КАК Субъект
	|ГДЕ
	|	Субъект.Ссылка = &Ссылка
	|;";
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Предприятие");
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции

// Осуществляет поиск соответствия данных ВетИС по прикладным реквизитам
//   Возвращает заполненные реквизиты при однозначном соответствии.
//
// Параметры:
//  ОрганизацияКонтрагентГосИС          - ОпределяемыйТип.ОрганизацияКонтрагентГосИС - организация
//  ТорговыйПроизводственныйОбъектВЕТИС - ОпределяемыйТип.ТорговыйОбъектВЕТИС, ОпределяемыйТип.ПроизводственныйОбъектИС - склад или подразделение
//
// Возвращаемое значение:
//  Структура - найденное соответствие, см. ХозяйствующийСубъектИПредприятие()
//
Функция ХозяйствующийСубъектИПредприятиеПоПрикладнымРеквизитам(ОрганизацияКонтрагентГосИС, ТорговыйПроизводственныйОбъектВЕТИС) Экспорт
	
	Если Метаданные.ОпределяемыеТипы.ТорговыйОбъектВЕТИС.Тип.СодержитТип(ТипЗнч(ТорговыйПроизводственныйОбъектВЕТИС)) Тогда
		Возврат ХозяйствующийСубъектИПредприятиеПоОрганизацииИСкладу(ОрганизацияКонтрагентГосИС, ТорговыйПроизводственныйОбъектВЕТИС);
	Иначе
		Возврат ХозяйствующийСубъектИПредприятиеПоОрганизацииИПодразделению(ОрганизацияКонтрагентГосИС, ТорговыйПроизводственныйОбъектВЕТИС);
	КонецЕсли;
	
КонецФункции

// Записывает в справочник "Хозяйствующие субъекты ВетИС" соответствие прикладных реквизитов
//   * Не изменяет существующие сопоставления (поле Контрагент)
//   * Добавляет предприятия ХС при необходимости.
//
// Параметры:
//   ХозяйствующийСубъектВЕТИС           - СправочникСсылка.ХозяйствующиеСубъектыВЕТИС - данные классификатора ВетИС
//   ПредприятиеВЕТИС                    - СправочникСсылка.ПредприятияВЕТИС           - данные классификатора ВетИС
//   ОрганизацияКонтрагентГосИС          - ОпределяемыйТип.ОрганизацияКонтрагентГосИС  - прикладной справочник
//   ТорговыйПроизводственныйОбъектВЕТИС - ОпределяемыйТип.ТорговыйОбъектВЕТИС,
//                                         ОпределяемыйТип.ПроизводственныйОбъектИС - прикладной справочник
//   СоответствуетОрганизации             - Булево                                     - флаг организации
//
Процедура СопоставитьСПрикладнымиРеквизитами(
	ХозяйствующийСубъектВЕТИС,
	ПредприятиеВЕТИС,
	ОрганизацияКонтрагентГосИС,
	ТорговыйПроизводственныйОбъектВЕТИС,
	СоответствуетОрганизации) Экспорт
	
	Если Не ЗначениеЗаполнено(ПредприятиеВЕТИС)
		Или Не ЗначениеЗаполнено(ХозяйствующийСубъектВЕТИС) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРеквизита = "ПроизводственныйОбъект";
	Если Метаданные.ОпределяемыеТипы.ТорговыйОбъектВЕТИС.Тип.СодержитТип(ТипЗнч(ТорговыйПроизводственныйОбъектВЕТИС)) Тогда
		ИмяРеквизита = "ТорговыйОбъект";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",      ХозяйствующийСубъектВЕТИС);
	Запрос.УстановитьПараметр("Предприятие", ПредприятиеВЕТИС);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ХозяйствующиеСубъектыВЕТИС.Контрагент                        КАК Контрагент,
	|	ХозяйствующиеСубъектыВЕТИСПредприятия.ТорговыйОбъект         КАК ТорговыйОбъект,
	|	ХозяйствующиеСубъектыВЕТИСПредприятия.ПроизводственныйОбъект КАК ПроизводственныйОбъект
	|ИЗ
	|	Справочник.ХозяйствующиеСубъектыВЕТИС КАК ХозяйствующиеСубъектыВЕТИС
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХозяйствующиеСубъектыВЕТИС.Предприятия КАК ХозяйствующиеСубъектыВЕТИСПредприятия
	|		ПО ХозяйствующиеСубъектыВЕТИСПредприятия.Ссылка = ХозяйствующиеСубъектыВЕТИС.Ссылка
	|ГДЕ
	|	ХозяйствующиеСубъектыВЕТИС.Ссылка = &Ссылка
	|	И ХозяйствующиеСубъектыВЕТИСПредприятия.Предприятие = &Предприятие";
	Выборка = Запрос.Выполнить().Выбрать();
	ТребуетсяЗаполнение = Истина;
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Контрагент) И Выборка.Контрагент <> ОрганизацияКонтрагентГосИС Тогда
			ТребуетсяЗаполнение = Ложь;
		КонецЕсли;
		Если ЗначениеЗаполнено(ТорговыйПроизводственныйОбъектВЕТИС)
			И (ТорговыйПроизводственныйОбъектВЕТИС = Выборка.ТорговыйОбъект 
				ИЛИ ТорговыйПроизводственныйОбъектВЕТИС = Выборка.ПроизводственныйОбъект) Тогда
			ТребуетсяЗаполнение = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Если ТребуетсяЗаполнение Тогда
		
		ХозяйствующийСубъектВЕТИСОбъект = ХозяйствующийСубъектВЕТИС.ПолучитьОбъект();
		Если Не ЗначениеЗаполнено(ХозяйствующийСубъектВЕТИСОбъект.Контрагент) Тогда
			ХозяйствующийСубъектВЕТИСОбъект.Контрагент = ОрганизацияКонтрагентГосИС;
			ХозяйствующийСубъектВЕТИСОбъект.СоответствуетОрганизации = СоответствуетОрганизации;
		КонецЕсли;
		
		СтрокиПредприятия = ХозяйствующийСубъектВЕТИСОбъект.Предприятия.НайтиСтроки(Новый Структура("Предприятие", ПредприятиеВЕТИС));
		ТребуетсяНоваяСтрока = Истина;
		Для Каждого Предприятие Из СтрокиПредприятия Цикл
			Если Не ЗначениеЗаполнено(Предприятие[ИмяРеквизита]) Тогда
				ТребуетсяНоваяСтрока = Ложь;
				Предприятие[ИмяРеквизита] = ТорговыйПроизводственныйОбъектВЕТИС;
			КонецЕсли;
		КонецЦикла;
		
		Если ТребуетсяНоваяСтрока Тогда
			Предприятие = ХозяйствующийСубъектВЕТИСОбъект.Предприятия.Добавить();
			Предприятие.Предприятие = ПредприятиеВЕТИС;
			Предприятие[ИмяРеквизита] = ТорговыйПроизводственныйОбъектВЕТИС;
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Истина);
		ХозяйствующийСубъектВЕТИСОбъект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция возвращает структуру с полями "Хозяйствующий субъект", "Предприятие"
// 
// Возвращаемое значение:
//  Структура - структура с полями:
//   * ХозяйствующийСубъект - СправочникСсылка.ХозяйствующиеСубъектыВЕТИС - пустая ссылка.
//   * Предприятие          - СправочникСсылка.ПредприятияВЕТИС - пустая ссылка.
//
Функция ХозяйствующийСубъектИПредприятие()
	
	Результат = Новый Структура;
	Результат.Вставить("ХозяйствующийСубъект", ПустаяСсылка());
	Результат.Вставить("Предприятие",          Справочники.ПредприятияВЕТИС.ПустаяСсылка());
	Возврат Результат;
	
КонецФункции

// Функция осуществляет поиск соответствия данных ВетИС по прикладным реквизитам
//
// Параметры:
//  Организация - ОпределяемыйТип.ОрганизацияКонтрагентГосИС - организация
//  Склад       - ОпределяемыйТип.ТорговыйОбъектВЕТИС - склад
// 
// Возвращаемое значение:
//  Структура - найденное соответствие, см. ХозяйствующийСубъектИПредприятие()
//
Функция ХозяйствующийСубъектИПредприятиеПоОрганизацииИСкладу(Организация, Склад)
	
	Результат = ХозяйствующийСубъектИПредприятие();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад"      , Склад);
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	Субъект.Ссылка КАК ХозяйствующийСубъект,
	|	ЕСТЬNULL(СубъектПредприятия.Предприятие, ЗНАЧЕНИЕ(Справочник.ПредприятияВЕТИС.ПустаяСсылка)) КАК Предприятие
	|ИЗ
	|	Справочник.ХозяйствующиеСубъектыВЕТИС КАК Субъект
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХозяйствующиеСубъектыВЕТИС.Предприятия КАК СубъектПредприятия
	|		ПО Субъект.Ссылка = СубъектПредприятия.Ссылка
	|		И СубъектПредприятия.ТорговыйОбъект = &Склад
	|ГДЕ
	|	НЕ Субъект.ПометкаУдаления
	|	И НЕ ЕСТЬNULL(СубъектПредприятия.НеИспользовать, Ложь)
	|	И (Субъект.Контрагент = &Организация ИЛИ &Организация = Неопределено)";
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет поиск соответствия данных ВетИС по прикладным реквизитам
//
// Параметры:
//  Организация   - ОпределяемыйТип.ОрганизацияКонтрагентГосИС - организация
//  Подразделение - ОпределяемыйТип.ПроизводственныйОбъектИС - подразделение
// 
// Возвращаемое значение:
//  Структура - см. ХозяйствующийСубъектИПредприятие
//
Функция ХозяйствующийСубъектИПредприятиеПоОрганизацииИПодразделению(Организация,Подразделение) Экспорт
	
	Результат = ХозяйствующийСубъектИПредприятие();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация"   , Организация);
	Запрос.УстановитьПараметр("Подразделение" , Подразделение);
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	Субъект.Ссылка                                                                               КАК ХозяйствующийСубъект,
	|	ЕСТЬNULL(СубъектПредприятия.Предприятие, ЗНАЧЕНИЕ(Справочник.ПредприятияВЕТИС.ПустаяСсылка)) КАК Предприятие
	|ИЗ
	|	Справочник.ХозяйствующиеСубъектыВЕТИС КАК Субъект
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХозяйствующиеСубъектыВЕТИС.Предприятия КАК СубъектПредприятия
	|		ПО Субъект.Ссылка = СубъектПредприятия.Ссылка
	|		И СубъектПредприятия.ПроизводственныйОбъект = &Подразделение
	|ГДЕ
	|	НЕ Субъект.ПометкаУдаления
	|	И НЕ СубъектПредприятия.НеИспользовать
	|	И Субъект.Контрагент = &Организация";
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции


// Функция осуществляет поиск соответствия данных ВетИС по прикладным реквизитам
//
// Параметры:
//  Организация   - ОпределяемыйТип.ОрганизацияКонтрагентГосИС - организация
// 
// Возвращаемое значение:
//  Массив из СправочникСсылка.ХозяйствующиеСубъектыВЕТИС - найденные ХозяйствующиеСубъекты, соотвестующие организации.
//
Функция ХозяйствующиеСубъектыПоОрганизации(Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация"   , Организация);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Субъект.Ссылка  КАК ХозяйствующийСубъект
	|ИЗ
	|	Справочник.ХозяйствующиеСубъектыВЕТИС КАК Субъект
	|ГДЕ
	|	НЕ Субъект.ПометкаУдаления
	|	И Субъект.Контрагент = &Организация";
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		ХозяйствующиеСубъекты = Неопределено;
	Иначе
		ХозяйствующиеСубъекты = Результат.Выгрузить().ВыгрузитьКолонку("ХозяйствующийСубъект")
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ХозяйствующиеСубъекты;
	
КонецФункции

#КонецОбласти

#КонецЕсли
