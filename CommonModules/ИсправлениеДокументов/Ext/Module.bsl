﻿#Область ПрограммныйИнтерфейс

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - См. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
// 	ОбъектМетаданных - ОбъектМетаданныхДокумент - Объект метаданных, для которого необходимо добавить команды.
// 	ХозяйственнаяОперация - Массив Из ПеречислениеСсылка.ХозяйственныеОперации -
// 	                     - ПеречислениеСсылка.ХозяйственныеОперации - Операции, для которых доступно исправление/сторно.
// 	                                                                  Если Неопределено, то доступно для всех операций документа.
// 	РазрешитьСторно - Булево - Для документа разрешено аннулирование. Значение по умолчанию Истина.
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, ОбъектМетаданных, ХозяйственнаяОперация = Неопределено, РазрешитьСторно = Истина) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьИсправлениеДокументов") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Редактирование", ОбъектМетаданных) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Исправление", ОбъектМетаданных) Тогда
		КомандаСоздатьИсправление = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьИсправление.Менеджер = ОбъектМетаданных.ПолноеИмя();
		КомандаСоздатьИсправление.Представление = НСтр("ru = 'Исправление'");
		КомандаСоздатьИсправление.РежимЗаписи = "Проводить";
		КомандаСоздатьИсправление.Порядок = 1000;
	КонецЕсли;
	
	Если РазрешитьСторно Тогда
		КомандаСоздатьСторно = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьСторно.Менеджер = Метаданные.Документы.Сторно.ПолноеИмя();
		КомандаСоздатьСторно.Представление = НСтр("ru = 'Сторно'");
		КомандаСоздатьСторно.РежимЗаписи = "Проводить";
		КомандаСоздатьСторно.Порядок = 1001;
	КонецЕсли;
	
	Если ХозяйственнаяОперация <> Неопределено Тогда 
		СписокХозяйственныхОпераций = Новый СписокЗначений();
		Если ТипЗнч(ХозяйственнаяОперация) = Тип("Массив") Тогда
			СписокХозяйственныхОпераций.ЗагрузитьЗначения(ХозяйственнаяОперация);
		Иначе
			СписокХозяйственныхОпераций.Добавить(ХозяйственнаяОперация);
		КонецЕсли;
		ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаСоздатьИсправление, 
			"ХозяйственнаяОперация", 
			СписокХозяйственныхОпераций,
			ВидСравненияКомпоновкиДанных.ВСписке);
			
		Если РазрешитьСторно Тогда
			ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаСоздатьСторно,
				"ХозяйственнаяОперация", 
				СписокХозяйственныхОпераций,
				ВидСравненияКомпоновкиДанных.ВСписке);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет исправительный документ на основании исправляемого.
// 
// Параметры:
// 	ДокументОбъект - ДокументОбъект, ДокументОбъект.ПеремещениеТоваров - Исправительный документ
// 	ИсправляемыйДокумент - ДокументСсылка, ДокументСсылка.ПеремещениеТоваров - Исправляемый документ
//
Процедура ЗаполнитьИсправление(ДокументОбъект, ИсправляемыйДокумент) Экспорт
	
	Если Не РегистрацияСторноРазрешена(ИсправляемыйДокумент) Тогда
		ВызватьИсключение НСтр("ru = 'Исправление документа не поддерживается.'");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеестрДокументов.Ссылка КАК Ссылка
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|ГДЕ
	|	РеестрДокументов.ТипСсылки = &ТипСсылки
	|	И РеестрДокументов.СторнируемыйДокумент = &СторнируемыйДокумент
	|	И РеестрДокументов.Проведен";
	Запрос.УстановитьПараметр("ТипСсылки", ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ДокументОбъект.Метаданные().ПолноеИмя()));
	Запрос.УстановитьПараметр("СторнируемыйДокумент", ИсправляемыйДокумент);
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	Если Выборка.Следующий() Тогда
		Если ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.Сторно") Тогда
			ТекстСообщения = НСтр("ru = 'На основании введен документ ""Сторно"".
			                            |Исправление документа невозможно.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'На основании уже введен исправительный документ.
			                            |Исправление может быть введено только на основании последнего исправительного документа.'");
		КонецЕсли;
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	ИсправляемыйДокументОбъект = ИсправляемыйДокумент.ПолучитьОбъект();
	
	МетаданныеОбъекта = ИсправляемыйДокументОбъект.Метаданные();
	МассивИсключаемыхРеквизитов = Новый Массив;
	МассивИсключаемыхРеквизитов.Добавить("Номер");
	МассивИсключаемыхРеквизитов.Добавить("Дата");
	МассивИсключаемыхРеквизитов.Добавить("Проведен");
	МассивИсключаемыхРеквизитов.Добавить("ПометкаУдаления");
	МассивИсключаемыхРеквизитов.Добавить("Ссылка");
	Если МетаданныеОбъекта.Реквизиты.Найти("Автор") <> Неопределено Тогда
		МассивИсключаемыхРеквизитов.Добавить("Автор");
	КонецЕсли;
	Если МетаданныеОбъекта.Реквизиты.Найти("Ответственный") <> Неопределено Тогда
		МассивИсключаемыхРеквизитов.Добавить("Ответственный");
	КонецЕсли;
	Если МетаданныеОбъекта.Реквизиты.Найти("Автор") <> Неопределено Тогда
		МассивИсключаемыхРеквизитов.Добавить("Автор");
	КонецЕсли;
		
	ЗаполнитьЗначенияСвойств(ДокументОбъект, ИсправляемыйДокументОбъект, , СтрСоединить(МассивИсключаемыхРеквизитов, ","));
	Для каждого ТабличнаяЧасть Из ДокументОбъект.Метаданные().ТабличныеЧасти Цикл
		ДокументОбъект[ТабличнаяЧасть.Имя].Загрузить(ИсправляемыйДокументОбъект[ТабличнаяЧасть.Имя].Выгрузить());
	КонецЦикла;
	
	ДокументОбъект.Исправление = Истина;
	ДокументОбъект.СторнируемыйДокумент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИсправляемыйДокумент, "Ссылка");
	Если Не ЗначениеЗаполнено(ДокументОбъект.ИсправляемыйДокумент) Тогда
		ДокументОбъект.ИсправляемыйДокумент = ДокументОбъект.СторнируемыйДокумент;
	КонецЕсли;
	
КонецПроцедуры

// Очищает реквизиты исправления при копировании документа.
// 
// Параметры:
// 	ДокументОбъект - ДокументОбъект, ДокументОбъект.ПеремещениеТоваров - Объект, который создан копированием
// 	ОбъектКопирования - ДокументОбъект, ДокументОбъект.ПеремещениеТоваров - Ссылка на документ, который копируется
//
Процедура ПриКопировании(ДокументОбъект, ОбъектКопирования) Экспорт
	
	ДокументОбъект.Исправление = Ложь;
	ДокументОбъект.СторнируемыйДокумент = Неопределено;
	ДокументОбъект.ИсправляемыйДокумент = Неопределено;
	
КонецПроцедуры

// Проверяет возможность записи объекта.
// 
// Параметры:
// 	ДокументОбъект - ДокументОбъект, ДокументОбъект.ПеремещениеТоваров - Объект, который записывается.
// 	Отказ - Булево - Флаг отказа записи.
// 	РежимЗаписи - РежимЗаписиДокумента - Режим записи документа.
// 	РежимПроведения - РежимПроведенияДокумента - Режим проведения документа.
//
Процедура ПередЗаписью(ДокументОбъект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьИсправлениеДокументов") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДокументОбъект.Ссылка) Тогда
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеестрДокументов.Ссылка КАК Ссылка
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|ГДЕ
	|	РеестрДокументов.ТипСсылки = &ТипСсылки
	|	И РеестрДокументов.СторнируемыйДокумент = &Ссылка
	|	И РеестрДокументов.Проведен
	|";
	Запрос.УстановитьПараметр("ТипСсылки", ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ДокументОбъект.Метаданные().ПолноеИмя()));
	Запрос.УстановитьПараметр("Ссылка", ДокументОбъект.Ссылка);
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	Если Выборка.Следующий() Тогда
		Если ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.Сторно") Тогда
			ТекстСообщения = НСтр("ru = 'На основании документа введен документ ""Сторно"".
				                        |Запись документа невозможна.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'На основании документа введено исправление.
				                        |Запись документа невозможна.'");
		КонецЕсли;
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет корректность заполнения исправительного/исправляемого документа.
// 
// Параметры:
// 	ДокументОбъект -  ДокументОбъект, ДокументОбъект.ПеремещениеТоваров - Объект, заполнение которого требуется проверить.
// 	Отказ - Булево - Флаг отказа записи.
// 	ПроверяемыеРеквизиты - Массив из Строка - Массив проверяемых реквизитов.
//
Процедура ОбработкаПроверкиЗаполнения(ДокументОбъект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Если ДокументОбъект.Исправление Тогда
		ПроверитьЗаполнениеИсправительногоДокумента(ДокументОбъект, Отказ);
	Иначе
		НепроверяемыеРеквизиты.Добавить("СторнируемыйДокумент");
		НепроверяемыеРеквизиты.Добавить("ИсправляемыйДокумент");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

// Проверяет корректность заполнения Сторно.
// 
// Параметры:
// 	ДокументОбъект -  ДокументОбъект.Сторно - Объект, заполнение которого требуется проверить.
// 	Отказ - Булево - Флаг отказа записи.
// 	ПроверяемыеРеквизиты - Массив из Строка - Массив проверяемых реквизитов.
//
Процедура ПроверитьЗаполнениеСторно(ДокументОбъект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	ПроверитьЗаполнениеИсправительногоДокумента(ДокументОбъект, Отказ);
	
КонецПроцедуры

// Формирует строку с информации об исправлении.
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма документа:
// 		* Объект - ДанныеФормыКоллекция - Документ объект:
// 			* Ссылка - ДокументСсылка -
// 	ЭлементИсправление - ПолеФормы - Поле с информацией об исправлении.
//
Процедура ПриСозданииНаСервере(Форма, ЭлементИсправление) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьИсправлениеДокументов") Тогда
		ЭлементИсправление.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма.Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	ПриЧтенииСозданииНаСервере(Форма, ЭлементИсправление)
	
КонецПроцедуры

// Формирует строку с информации об исправлении.
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма документа.
// 	ЭлементИсправление - ПолеФормы - Поле с информацией об исправлении.
//
Процедура ПриЧтенииНаСервере(Форма, ЭлементИсправление) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьИсправлениеДокументов") Тогда
		Возврат;
	КонецЕсли;
	
	ПриЧтенииСозданииНаСервере(Форма, ЭлементИсправление);
	
КонецПроцедуры

// Устанавливает номер исправительного документа, для тех типов документа, для которых важно
// сохранить последовательную нумерацию исправляемых документов.
// 
// Параметры:
// 	ДокументОбъект - ДокументОбъект - Исправительный документ
// 	СтандартнаяОбработка - Булево - признак выполнения стандартной (системной) обработки события.
// 	Префикс - Строка - Префикс, который будет использоваться для генерации номера.
Процедура ПриУстановкеНовогоНомера(ДокументОбъект, СтандартнаяОбработка, Префикс) Экспорт
	
	Если ДокументОбъект.Исправление Тогда
		Префикс = НСтр("ru = 'И'", ОбщегоНазначения.КодОсновногоЯзыка());;
		СтандартнаяОбработка = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает Истина, если документ является исправлением.
//
// Параметры:
// 	ДокументОбъект - ДокументОбъект - Документ, для которого необходимо выполнить проверку
//
// Возвращаемое значение:
//	Булево - 
Функция ЭтоИсправительныйДокумент(ДокументОбъект) Экспорт
	
	Результат = Ложь;
	Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.Сторно") Тогда
		Результат = Истина;
	ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("Исправление", ДокументОбъект.Метаданные()) Тогда
		Результат = ДокументОбъект.Исправление;		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак возможности регистрации исправительного (сторнирующего) документа.
// Если исправление (сторнирование) не может быть выполнено, то выдается сообщение.
// 
// Параметры:
// 	СторнируемыйДокумент - ДокументОбъект - Исправительный (сторнирующий) документ.
// 	
// Возвращаемое значение:
// 	Булево - 
Функция РегистрацияСторноРазрешена(СторнируемыйДокумент) Экспорт
	
	Отказ = Ложь;
	
	// Если документ введен в периоде использования партионного учета 2.1, то исправления не поддерживаются.
	ДатаИсправляемогоДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СторнируемыйДокумент, "Дата");
	МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(СторнируемыйДокумент);
	УчетныеМеханизмы = ПроведениеДокументов.УчетныеМеханизмыДокумента(МенеджерДокумента);
	Если УчетныеМеханизмы.Найти("СебестоимостьИПартионныйУчет") <> Неопределено
		 Или УчетныеМеханизмы.Найти("УчетДоходовРасходов") <> Неопределено Тогда
		ЗатратыСервер.ПроверитьИспользованиеПартионногоУчета22(СторнируемыйДокумент, ДатаИсправляемогоДокумента, Отказ);
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

// Возвращает Истина, если выполнено исправление или сторно документа.
//
// Параметры:
//	Документ - ДокументСсылка - Документ, для которого необходимо выполнить проверку
//
// Возвращаемое значение:
// 	Булево - Результат проверки
Функция ЕстьИсправлениеИлиСторно(Документ) Экспорт
	
	Если Не Метаданные.ОпределяемыеТипы.ИсправляемыеДокументы.Тип.СодержитТип(ТипЗнч(Документ)) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РеестрДокументов.Ссылка КАК Ссылка
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|ГДЕ
	|	РеестрДокументов.ТипСсылки = &ТипСсылки
	|	И РеестрДокументов.СторнируемыйДокумент  = &Документ
	|	И РеестрДокументов.СторноИсправление
	|	И РеестрДокументов.Проведен";
	Запрос.УстановитьПараметр("ТипСсылки", ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Документ.Метаданные().ПолноеИмя()));
	Запрос.УстановитьПараметр("Документ", Документ);
	
	УстановитьПривилегированныйРежим(Истина);
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Возвращает сторнирующие документы
//
// Параметры:
//	СторнируемыеДокументы - Массив Из ДокументСсылка - Документы, для которых необходимо найти сторно
//
// Возвращаемое значение:
// 	ТаблицаЗначений - Сторнирующие документы:
// 		* Ссылка - ДокументСсылка - 
// 		* СторнируемыйДокумент - ДокументСсылка - 
Функция СторноДокументы(СторнируемыеДокументы) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеестрДокументов.Ссылка КАК Ссылка,
	|	РеестрДокументов.СторнируемыйДокумент КАК СторнируемыйДокумент
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|ГДЕ
	|	РеестрДокументов.СторнируемыйДокумент В (&СторнируемыеДокументы)
	|	И НЕ РеестрДокументов.ДополнительнаяЗапись
	|	И РеестрДокументов.Проведен
	|";
	Запрос.УстановитьПараметр("СторнируемыеДокументы", СторнируемыеДокументы);
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

// Возвращает исправляемый документ (первый документ цепочки) по исправлению
//
//	Параметры:
//		Исправление - ДокументСсылка - Исправление
//	
//	Возвращаемое значение:
//		ДокументСсылка -
//
Функция ИсправляемыйДокумент(Знач Исправление) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	Возврат РегистрыСведений.ИсправленияДокументов.ИсправляемыйДокумент(Исправление);

КонецФункции

#Область ИсправлениеДокументов

// Возвращает исправления документа
//
// Параметры:
//	ИсправляемыйДокумент - ДокументСсылка - Документ, для которого необходимо исправления
//
// Возвращаемое значение:
// 	Массив из ДокументСсылка - Массив исправлений документа.
//
Функция ИсправленияДокумента(Знач ИсправляемыйДокумент) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	Возврат РегистрыСведений.ИсправленияДокументов.ИсправленияДокумента(ИсправляемыйДокумент);	

КонецФункции	

// Возвращает исправления документов по типу документа исправления
//
// Параметры:
//	ИсправляемыеДокументы - Массив из ДокументСсылка - документы, для которых необходимы исправления
//	ТипИсправления - Строка - тип документа исправления
//	
// Возвращаемое значение:
// 	Массив из ДокументСсылка - Массив исправлений документов.
//
Функция ИсправленияДокументовПоТипуИсправления(Знач ИсправляемыеДокументы, Знач ТипИсправления) Экспорт
		
	УстановитьПривилегированныйРежим(Истина);

	Возврат РегистрыСведений.ИсправленияДокументов.ИсправленияДокументовПоТипуИсправления(ИсправляемыеДокументы, ТипИсправления);	
	
КонецФункции

// Возвращает представление документа
//
// Параметры:
//	ИсправляемыйДокумент - ДокументСсылка - Документ, для которого необходимо представление
//
// Возвращаемое значение:
// 	Строка - Представление исправляемого документа
//
Функция ПредставлениеИсправляемогоДокумента(Знач ИсправляемыйДокумент) Экспорт
	
	ПредставлениеИсправляемогоДокумента = "";		
	
	Если НЕ ЗначениеЗаполнено(ИсправляемыйДокумент) Тогда
		Возврат ПредставлениеИсправляемогоДокумента;		
	КонецЕсли;	
	
	ДанныеИсправляемогоДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ИсправляемыйДокумент, 
		"Дата, Номер");	
		
	НомерИсправляемогоДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеИсправляемогоДокумента.Номер);
	ДатаИсправляемогоДокумента = Формат(ДанныеИсправляемогоДокумента.Дата, "ДЛФ=D;");
	
	ШаблонПредставления = НСтр("ru = '%1 от %2'"); 

	ПредставлениеИсправляемогоДокумента = СтрШаблон(ШаблонПредставления, 
		НомерИсправляемогоДокумента, ДатаИсправляемогоДокумента);		
	
	Возврат ПредставлениеИсправляемогоДокумента;
	
КонецФункции

// Проверяет изменились ли параметры регистратора относительно хранимых записей в регистре Исправление документов.
//
// Параметры:
//  ПараметрыПроверки - См. РегистрыСведений.ИсправленияДокументов.ПараметрыПроверкиИсправленияДокументов
// 
// Возвращаемое значение:
//  Булево - Истина - параметры изменились, Ложь - нет.
//
Функция ИзменилисьПараметрыИсправленияДокументов(ПараметрыПроверки) Экспорт
	
	Возврат РегистрыСведений.ИсправленияДокументов.ИзменилисьПараметрыИсправленияДокументов(ПараметрыПроверки);
	
КонецФункции

// Возвращает документ-исправление после даты проверяемого документа.
//
// Параметры:
//  ПараметрыПроверки - См. РегистрыСведений.ИсправленияДокументов.ПараметрыПроверкиИсправленияДокументов
// 
// Возвращаемое значение:
//  ДокументСсылка, Неопределено - Регистраторы регистра РегистрСведений.ИсправляемыеДокументы
//
Функция ИсправлениеПослеДатыДокумента(ПараметрыПроверки) Экспорт
	
	Возврат РегистрыСведений.ИсправленияДокументов.ИсправлениеПослеДатыДокумента(ПараметрыПроверки);
	
КонецФункции

// Возвращает признак наличия актуальных исправлений документа на дату 
//
// Параметры:
//	ИсправляемыйДокумент - ДокументСсылка - исправляемый документ
//	СторнируемыйДокумент - ДокументСсылка - сторнируемый документ
//	Дата - Дата - Дата проверки
//
// Возвращаемое значение:
// 	Булево - Если Истина - Есть актуальные исправления по сторнируемому документу
//
Функция НаличиеИсправленийНаДатуДокумента(ИсправляемыйДокумент, СторнируемыйДокумент, Дата) Экспорт
	
	Возврат РегистрыСведений.ИсправленияДокументов.НаличиеИсправленийНаДатуДокумента(ИсправляемыйДокумент, СторнируемыйДокумент, Дата);
	
КонецФункции

#КонецОбласти

#Область Проведение

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
// 	МетаданныеДокумента - ОбъектМетаданныхДокумент - Объект метаданных документа, который проводится
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры, МетаданныеДокумента) Экспорт

	ТекстЗапросаТаблицаИсправленияДокументов(Запрос, ТекстыЗапроса, Регистры, МетаданныеДокумента);
		
КонецПроцедуры

// Функция-конструктор параметров учетного механизма.
//
// Параметры:
//  Документ - ДокументОбъект - записываемый документ
//  Свойства - См. ПроведениеДокументов.СвойстваДокумента
//
// Возвращаемое значение:
//  Структура - См. ПроведениеДокументов.ПараметрыУчетногоМеханизма
//
Функция ПараметрыДляПроведенияДокумента(Документ, Свойства) Экспорт
	
	Параметры = ПроведениеДокументов.ПараметрыУчетногоМеханизма();
	
	// Проведение
	Если Свойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыСведений.ИсправленияДокументов);
		
	КонецЕсли;	
	
	Возврат Параметры;	
		
КонецФункции

// Загружает для записи данные в набор записей движений документа по указанному регистру.
//
// Параметры:
//	ТаблицыДляДвижений - Структура - таблицы данных документа
//	Движения - КоллекцияДвижений - коллекция наборов записей движений документа
//	Отказ - Булево - признак отказа от проведения документа.
//
Процедура ОтразитьДвижения(ТаблицыДляДвижений, Движения, Отказ) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "ИсправленияДокументов");
	
КонецПроцедуры

// Возвращает тексты запросов для сторнирования движений при исправлении документов
// 
// Параметры:
// 	МетаданныеДокумента - ОбъектМетаданныхДокумент - Метаданные документа, который проводится.
// 
// Возвращаемое значение:
// 	Соответствие - Соответствие полного имени регистра тексту запроса сторнирования
//
Функция ТекстыЗапросовСторнирования(МетаданныеДокумента) Экспорт
	
	ТекстыЗапросов = Новый Соответствие();
	
	Возврат ТекстыЗапросов;
	
КонецФункции

// Дополняет текст запроса механизма проверки даты запрета по таблице изменений.
// 
// Параметры:
// 	Запрос - Запрос - используется для установки параметров запроса.
// 
// Возвращаемое значение:
//	Соответствие - соответствие имен таблиц изменения регистров и текстов запросов.
//	
Функция ТекстыЗапросовКонтрольДатыЗапретаПоТаблицеИзменений(Запрос) Экспорт

	СоответствиеТекстовЗапросов = Новый Соответствие();
	Возврат СоответствиеТекстовЗапросов;
	
КонецФункции

// Процедура формирования движений по регистру.
//
// Параметры:
//	ТаблицыДляДвижений - Структура - таблицы данных документа
//	Документ - ДокументСсылка - ссылка на документ
//	МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - менеджер временных таблиц документа
//	Отказ - Булево - признак отказа от проведения документа.
//
Процедура ЗаписатьДанные(ТаблицыДляДвижений, Документ, МенеджерВременныхТаблиц, Отказ) Экспорт
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьЗаполнениеИсправительногоДокумента(ДокументОбъект, Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеестрДокументов.Ссылка,
	|	РеестрДокументов.ДатаДокументаИБ КАК Дата,
	|	РеестрДокументов.НомерДокументаИБ КАК Номер,
	|	РеестрДокументов.Проведен КАК Проведен
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|ГДЕ
	|	РеестрДокументов.ТипСсылки = &ТипСсылки
	|	И РеестрДокументов.Ссылка = &СторнируемыйДокумент
	|;
	|
	|////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеестрДокументов.Ссылка,
	|	РеестрДокументов.ДатаДокументаИБ КАК Дата,
	|	РеестрДокументов.НомерДокументаИБ КАК Номер,
	|	РеестрДокументов.Проведен КАК Проведен
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|ГДЕ
	|	РеестрДокументов.ТипСсылки = &ТипСсылки
	|	И РеестрДокументов.СторнируемыйДокумент = &СторнируемыйДокумент
	|	И РеестрДокументов.Ссылка <> &Ссылка
	|	И РеестрДокументов.Проведен
	|";
	
	Запрос.УстановитьПараметр("ТипСсылки", ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ДокументОбъект.Метаданные().ПолноеИмя()));
	Запрос.УстановитьПараметр("СторнируемыйДокумент", ДокументОбъект.СторнируемыйДокумент);
	Запрос.УстановитьПараметр("Ссылка", ДокументОбъект.Ссылка);
	УстановитьПривилегированныйРежим(Истина);
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	УстановитьПривилегированныйРежим(Ложь);
	
	РеквизитыСторнируемогоДокумента = РезультатыЗапроса[0].Выбрать();
	Если Не РеквизитыСторнируемогоДокумента.Следующий() Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'По документу %1 нет данных в реестре документов.'"), ДокументОбъект.СторнируемыйДокумент);
	КонецЕсли;
	
	ДругиеИсправления = РезультатыЗапроса[1].Выбрать();
	Если ДругиеИсправления.Следующий() Тогда
		Если ТипЗнч(ДругиеИсправления.Ссылка) = Тип("ДокументСсылка.Сторно") Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'На основании ""%1"" введен документ ""Сторно"".
				                       |Ввод исправительного документа невозможен.'"),
				                       ДокументОбъект.СторнируемыйДокумент);
		Иначе
			ТекстСообщения = СтрШаблон(НСтр("ru = 'На основании ""%1"" уже введен исправительный документ.
				                       |Ввод нового документа возможен только на основании актуального исправительного документа.'"),
				                       ДокументОбъект.СторнируемыйДокумент);
		КонецЕсли;
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ДокументОбъект, , , Отказ);
	КонецЕсли;
	
	ЭтоПервоеИсправление = (ДокументОбъект.СторнируемыйДокумент = ДокументОбъект.ИсправляемыйДокумент);
	Если Не Отказ И Не РеквизитыСторнируемогоДокумента.Проведен Тогда
		Если ЭтоПервоеИсправление Тогда
			ТекстСообщения = НСтр("ru = 'Исправляемый документ не проведен.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Предыдущий исправительный документ не проведен.'");
		КонецЕсли;
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ДокументОбъект, , , Отказ);
	КонецЕсли;
	
	ДатаВремяИсправленияДляПроверки = ДокументОбъект.Дата;
	Если ДокументОбъект.ЭтоНовый()
		И ДокументОбъект.Метаданные().ОперативноеПроведение = Метаданные.СвойстваОбъектов.ОперативноеПроведение.Разрешить
		И ДатаВремяИсправленияДляПроверки = НачалоДня(ТекущаяДатаСеанса()) Тогда
		ДатаВремяИсправленияДляПроверки = КонецДня(ДатаВремяИсправленияДляПроверки);
	КонецЕсли;
	
	Если Не Отказ И РеквизитыСторнируемогоДокумента.Дата >= ДатаВремяИсправленияДляПроверки Тогда
		Если ЭтоПервоеИсправление Тогда
			ТекстСообщения = НСтр("ru = 'Дата исправления должна быть больше даты исправляемого документа.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Дата исправления должна быть больше даты предыдущего исправления.'");
		КонецЕсли;
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ДокументОбъект, "Дата", , Отказ);
	КонецЕсли;
		
КонецПроцедуры

// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма документа
// 	ЭлементИсправление - ПолеФормы - 
Процедура ПриЧтенииСозданииНаСервере(Форма, ЭлементИсправление)
	
	Объект = Форма.Объект;
	
	ВстроеноИсправление = ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "Исправление");
	
	Если ВстроеноИсправление И Объект.Исправление Тогда
		ИсправляемыйДокумент = Объект.ИсправляемыйДокумент;
	Иначе
		ИсправляемыйДокумент = Объект.Ссылка;
	КонецЕсли;
	
	ИсправительныйДокумент = ПоследнийИсправительныйДокумент(ИсправляемыйДокумент);
	
	Если (Не ВстроеноИсправление ИЛИ Не Объект.Исправление) И ИсправительныйДокумент <> Неопределено Тогда
		
		Форма[ЭлементИсправление.ПутьКДанным] = ГиперссылкаИсправленияДокумента(ИсправляемыйДокумент, ИсправительныйДокумент);
		ЭлементИсправление.Видимость = Истина;
		Форма.ТолькоПросмотр = Объект.Проведен;
		
	ИначеЕсли ВстроеноИсправление И Объект.Исправление Тогда
		
		РеквизитыИсправляемогоДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ИсправляемыйДокумент, "Номер, Дата");
		
		МассивПодстрок = Новый Массив;
		МассивПодстрок.Добавить(
			           СтроковыеФункции.ФорматированнаяСтрока(НСтр("ru = 'Исправление документа <a href=""%1"">%2 от %3</a>'"),
			           ПолучитьНавигационнуюСсылку(Объект.ИсправляемыйДокумент),
			           РеквизитыИсправляемогоДокумента.Номер,
			           Формат(РеквизитыИсправляемогоДокумента.Дата, "ДЛФ=DT")));
		
		ДругиеИсправленияДокумента = ДругиеИсправленияДокумента(ИсправляемыйДокумент, Объект.Ссылка);
		Если ДругиеИсправленияДокумента.Количество() > 0 Тогда
			МассивПодстрок.Добавить(" ");
			МассивПодстрок.Добавить(
				СтроковыеФункции.ФорматированнаяСтрока(
				                 НСтр("ru = '(См. <a href=""%1"">все исправления</a> документа)'"),
				                 "ОткрытьСписокИсправительныхДокументов"));
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.Ссылка) 
			И ИсправительныйДокумент <> Неопределено
			И Объект.Ссылка <> ИсправительныйДокумент.Ссылка Тогда
			Форма.ТолькоПросмотр = Объект.Проведен;
		КонецЕсли;
		
		Форма[ЭлементИсправление.ПутьКДанным] = Новый ФорматированнаяСтрока(МассивПодстрок);
		ЭлементИсправление.Видимость = Истина;
		
	Иначе
		ЭлементИсправление.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает текст гиперссылки на исправления документа для вывода в форме.
// 
// Параметры:
//  ИсправляемыйДокумент - ДокументСсылка - Исправляемый документ
//  ИсправительныйДокумент - Неопределено, Структура - Исправительный документ:
// * Ссылка 
// * Номер 
// * Дата 
// * СторнируемыйДокумент 
// 
// Возвращаемое значение:
//  Неопределено, ФорматированнаяСтрока - Гиперссылка исправления документа
Функция ГиперссылкаИсправленияДокумента(ИсправляемыйДокумент, ИсправительныйДокумент = Неопределено) Экспорт
	
		Если ИсправительныйДокумент = Неопределено Тогда
			ИсправительныйДокумент = ПоследнийИсправительныйДокумент(ИсправляемыйДокумент);
		КонецЕсли;
		
		МассивСтрок = Новый Массив;
		
		Если Не ИсправительныйДокумент = Неопределено Тогда
		
			Если ТипЗнч(ИсправительныйДокумент.Ссылка) = Тип("ДокументСсылка.Сторно") Тогда
				МассивСтрок.Добавить(
					СтроковыеФункции.ФорматированнаяСтрока(
					                 НСтр("ru = 'Введено сторно <a href=""%1"">%2 от %3</a>'"),
					                 ПолучитьНавигационнуюСсылку(ИсправительныйДокумент.Ссылка),
					                 ИсправительныйДокумент.Номер,
					                 Формат(ИсправительныйДокумент.Дата, "ДЛФ=DT")));
			Иначе
				МассивСтрок.Добавить(
					СтроковыеФункции.ФорматированнаяСтрока(
					                 НСтр("ru = 'Введено исправление <a href=""%1"">%2 от %3</a>'"),
					                 ПолучитьНавигационнуюСсылку(ИсправительныйДокумент.Ссылка),
					                 ИсправительныйДокумент.Номер,
					                 Формат(ИсправительныйДокумент.Дата, "ДЛФ=DT")));
				
			КонецЕсли;
			
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ИсправительныйДокумент, "СторнируемыйДокумент")
				И ИсправляемыйДокумент <> ИсправительныйДокумент.СторнируемыйДокумент Тогда
				
				МассивСтрок.Добавить(" ");
				МассивСтрок.Добавить(
					СтроковыеФункции.ФорматированнаяСтрока(
					                 НСтр("ru = '(См. <a href=""%1"">все исправления</a> документа)'"),
					                 "ОткрытьСписокИсправительныхДокументов"));
				
				
			КонецЕсли;
			
		КонецЕсли;
		
		Возврат ?(МассивСтрок.Количество(), Новый ФорматированнаяСтрока(МассивСтрок), Неопределено);
	
КонецФункции

// Возвращает последний исправительный документ.
// 
// Параметры:
//  ИсправляемыйДокумент - ДокументСсылка - Исправляемый документ
// 
// Возвращаемое значение:
//  Неопределено, Структура - Последний исправительный документ:
// 	* Ссылка - ДокументСсылка - Ссылка на документ
// 	* Номер  - Строка - Номер документа
// 	* Дата - Дата - Дата документа 
// 	* СторнируемыйДокумент - ДокументСсылка - Ссылка на сторнируемый документ
Функция ПоследнийИсправительныйДокумент(ИсправляемыйДокумент) Экспорт
	
	Результат = Неопределено;
	Если Не ЗначениеЗаполнено(ИсправляемыйДокумент) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеестрДокументов.Ссылка                КАК Ссылка,
	|	РеестрДокументов.НомерДокументаИБ      КАК Номер,
	|	РеестрДокументов.ДатаДокументаИБ       КАК Дата,
	|	РеестрДокументов.СторнируемыйДокумент  КАК СторнируемыйДокумент
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.РеестрДокументов КАК РеестрДокументовПоследующиеИсправления
	|	ПО
	|		РеестрДокументов.ТипСсылки = РеестрДокументовПоследующиеИсправления.ТипСсылки
	|		И РеестрДокументов.ИсправляемыйДокумент = РеестрДокументовПоследующиеИсправления.ИсправляемыйДокумент
	|		И РеестрДокументов.Ссылка = РеестрДокументовПоследующиеИсправления.СторнируемыйДокумент
	|		И НЕ РеестрДокументовПоследующиеИсправления.ДополнительнаяЗапись
	|		И РеестрДокументовПоследующиеИсправления.Проведен
	|		И РеестрДокументовПоследующиеИсправления.ДатаДокументаИБ > РеестрДокументов.ДатаДокументаИБ
	|ГДЕ
	|	РеестрДокументов.ТипСсылки = &ТипСсылки
	|	И (РеестрДокументов.ИсправляемыйДокумент = &ИсправляемыйДокумент
	|		ИЛИ РеестрДокументов.СторнируемыйДокумент = &ИсправляемыйДокумент)
	|	И РеестрДокументовПоследующиеИсправления.Ссылка ЕСТЬ NULL
	|	И НЕ РеестрДокументов.ДополнительнаяЗапись
	|	И РеестрДокументов.Проведен
	|";
	Запрос.УстановитьПараметр("ТипСсылки", ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ИсправляемыйДокумент.Метаданные().ПолноеИмя()));
	Запрос.УстановитьПараметр("ИсправляемыйДокумент", ИсправляемыйДокумент);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	Если Выборка.Следующий() Тогда
		Результат = Новый Структура;
		Результат.Вставить("Ссылка", Выборка.Ссылка);
		Результат.Вставить("Номер",  Выборка.Номер);
		Результат.Вставить("Дата",   Выборка.Дата);
		Результат.Вставить("СторнируемыйДокумент",   Выборка.СторнируемыйДокумент);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Параметры:
// 	ИсправляемыйДокумент - ДокументСсылка -
// 	ИсправительныйДокумент - ДокументСсылка -
// Возвращаемое значение:
// 	ТаблицаЗначений - Таблица с колонками:
// 		* Ссылка - ДокументСсылка -
// 		* Номер - Строка -
// 		* Дата - Дата -
// 		* СторнируемыйДокумент - ДокументСсылка -
Функция ДругиеИсправленияДокумента(ИсправляемыйДокумент, ИсправительныйДокумент)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеестрДокументов.Ссылка                КАК Ссылка,
	|	РеестрДокументов.НомерДокументаИБ      КАК Номер,
	|	РеестрДокументов.ДатаДокументаИБ       КАК Дата,
	|	РеестрДокументов.СторнируемыйДокумент  КАК СторнируемыйДокумент
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|ГДЕ
	|	РеестрДокументов.ТипСсылки = &ТипСсылки
	|	И РеестрДокументов.ИсправляемыйДокумент = &ИсправляемыйДокумент
	|	И РеестрДокументов.Ссылка <> &ИсправительныйДокумент
	|	И НЕ РеестрДокументов.ДополнительнаяЗапись
	|	И РеестрДокументов.Проведен
	|";
	Запрос.УстановитьПараметр("ТипСсылки", ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ИсправляемыйДокумент.Метаданные().ПолноеИмя()));
	Запрос.УстановитьПараметр("ИсправляемыйДокумент", ИсправляемыйДокумент);
	Запрос.УстановитьПараметр("ИсправительныйДокумент", ИсправительныйДокумент);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
// 	МетаданныеДокумента - ОбъектМетаданныхДокумент - Объект метаданных документа, который проводится
//
Процедура ТекстЗапросаТаблицаИсправленияДокументов(Запрос, ТекстыЗапроса, Регистры, МетаданныеДокумента)
	
	ИмяРегистра = "ИсправленияДокументов";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяДокумента = МетаданныеДокумента.Имя;

	// В первом исправлении  СторнируемыйДокумент = ИсправляемыйДокумент	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Документ.Дата КАК Период,
	|	Документ.ИсправляемыйДокумент КАК ИсправляемыйДокумент,
	|	ВЫБОР
	|		КОГДА Документ.СторнируемыйДокумент = Документ.ИсправляемыйДокумент
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ Документ.СторнируемыйДокумент
	|	КОНЕЦ КАК ПредыдущееИсправление,
	|	&Ссылка КАК ПоследнийДокументЦепочки,
	|	ЛОЖЬ КАК СторнированИсправляемыйДокумент,
	|	ИСТИНА КАК СпособИсправленияСторно
	|ИЗ
	|	&ИмяДокумента КАК Документ
	|ГДЕ
	|	Документ.Ссылка В (&Ссылка)
	|	И Документ.Исправление";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяДокумента", "Документ." + ИмяДокумента);
		
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

#КонецОбласти
