﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает реквизиты объекта, которые необходимо блокировать от изменения
//
// Возвращаемое значение:
//  Массив - блокируемые реквизиты объекта.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("Владелец");
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Анкета (mxl)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "";
	КомандаПечати.Идентификатор = "Анкета";
	КомандаПечати.Представление = НСтр("ru = 'Анкета (mxl)'");
	КомандаПечати.ТребуетсяРасширениеРаботыСФайлами = Истина;

	КартыЛояльностиЛокализация.ДобавитьКомандыПечати(КомандыПечати);
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Анкета") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Анкета", "Анкета", СформироватьПечатнуюФормуАнкеты(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьДанныеПечати(знач МассивДокументов, знач МассивИменМакетов) Экспорт
	
	Возврат Новый Структура("Данные,Макеты",
				ПолучитьДанныеОбъектаПоМакетам(МассивДокументов, МассивИменМакетов),
				ПолучитьМакетыИОписанияСекций(МассивИменМакетов));
	
КонецФункции

Функция ПолучитьОписаниеОбластейАнкета()

	Секции = Новый Структура;
	
	УправлениеПечатью.ДобавитьОписаниеОбласти(Секции, "Заголовок",    "Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(Секции, "Штрихкод",     "Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(Секции, "МагнитныйКод", "Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(Секции, "Подвал",       "Общая");
	
	Возврат Секции;

КонецФункции

Функция ПолучитьДанныеОбъектаПоМакетам(знач МассивДокументов, знач МассивИменМакетов) Экспорт
	
	ДанныеПоВсемОбъектам = Новый Соответствие;
	
	РезультатЗапроса = ПолучитьДанныеДляПечати(МассивДокументов);
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДанныеОбъектаПоМакетам = Новый Структура;
		ДанныеОбъекта = ПолучитьДанныеОбъектаПоВыборке(Выборка);
		Для Каждого ИмяМакета Из МассивИменМакетов Цикл
			ДанныеОбъектаПоМакетам.Вставить(ИмяМакета, ДанныеОбъекта);
		КонецЦикла;
		ДанныеПоВсемОбъектам.Вставить(Выборка.Ссылка, ДанныеОбъектаПоМакетам);
	КонецЦикла;
	
	Возврат ДанныеПоВсемОбъектам;
	
КонецФункции

// Параметры:
//  МассивИменМакетов - Массив - 
//
// Возвращаемое значение:
// 	Структура:
// * ОписаниеСекций - Структура
// * ДвоичныеДанныеМакетов - Структура
//
Функция ПолучитьМакетыИОписанияСекций(знач МассивИменМакетов) Экспорт
	
	ОписаниеСекций = Новый Структура;
	ДвоичныеДанныеМакетов = Новый Структура;
	
	Для Каждого ИмяМакета Из МассивИменМакетов Цикл
		
		Макет = Неопределено;
		ОписаниеСекцийМакета = Неопределено;
		
		Если ИмяМакета = "ПФ_DOC_Анкета" Тогда
			ОписаниеСекцийМакета = ПолучитьОписаниеОбластейАнкета();
			Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.КартыЛояльности.ПФ_DOC_Анкета");
		ИначеЕсли ИмяМакета = "ПФ_ODT_Анкета" Тогда
			ОписаниеСекцийМакета = ПолучитьОписаниеОбластейАнкета();
			Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.КартыЛояльности.ПФ_ODT_Анкета");
		КонецЕсли;
		
		Если ОписаниеСекцийМакета <> Неопределено И Макет <> Неопределено Тогда
			
			ОписаниеСекций.Вставить(ИмяМакета, ОписаниеСекцийМакета);
			ДвоичныеДанныеМакетов.Вставить(ИмяМакета, Макет);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Новый Структура(
						"ОписаниеСекций,ДвоичныеДанныеМакетов",
						ОписаниеСекций,
						ДвоичныеДанныеМакетов);
	
КонецФункции

Функция СформироватьПечатнуюФормуАнкеты(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	РезультатЗапроса = ПолучитьДанныеДляПечати(МассивОбъектов);
	Выборка = РезультатЗапроса.Выбрать();
	
	ПервыйДокумент = Истина;
	
	Пока Выборка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ЗаполнитьТабличныйДокументПоДаннымОбъекта(ТабличныйДокумент, ПолучитьДанныеОбъектаПоВыборке(Выборка));
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПолучитьДанныеДляПечати(МассивОбъектов)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КартыЛояльности.Ссылка                                  КАК Ссылка,
	|	КартыЛояльности.Штрихкод                                КАК Штрихкод,
	|	КартыЛояльности.МагнитныйКод                            КАК МагнитныйКод,
	|	КартыЛояльности.Владелец.Наименование                   КАК ВидКарты,
	|	КартыЛояльности.Владелец.ТипКарты                       КАК ТипКарты,
	|	КартыЛояльности.Владелец.Организация.НаименованиеПолное КАК Организация
	|ИЗ
	|	Справочник.КартыЛояльности КАК КартыЛояльности
	|ГДЕ
	|	КартыЛояльности.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	КартыЛояльности.Ссылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция ПолучитьДанныеОбъектаПоВыборке(Выборка)
	
	ДанныеОбъекта = Новый Структура;
	
	ДанныеОбъекта.Вставить("Ссылка",       Выборка.Ссылка);
	ДанныеОбъекта.Вставить("ТипКарты",     Выборка.ТипКарты);
	ДанныеОбъекта.Вставить("Штрихкод",     Выборка.Штрихкод);
	ДанныеОбъекта.Вставить("МагнитныйКод", Выборка.МагнитныйКод);
	ДанныеОбъекта.Вставить("ВидКарты",     Выборка.ВидКарты);
	ДанныеОбъекта.Вставить("Организация",  Выборка.Организация);
	
	Возврат ДанныеОбъекта;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументПоДаннымОбъекта(ТабличныйДокумент, ДанныеОбъекта)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.КартыЛояльности.ПФ_MXL_Анкета");
	
	Область = Макет.ПолучитьОбласть("Заголовок");
	Область.Параметры.ВидКарты = ДанныеОбъекта.ВидКарты;
	ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, Область, ДанныеОбъекта.Ссылка);
	ТабличныйДокумент.Вывести(Область);
	
	Если ДанныеОбъекта.ТипКарты = ПредопределенноеЗначение("Перечисление.ТипыКарт.Штриховая")
		ИЛИ ДанныеОбъекта.ТипКарты = ПредопределенноеЗначение("Перечисление.ТипыКарт.Смешанная") Тогда
		Область = Макет.ПолучитьОбласть("Штрихкод");
		Область.Параметры.Штрихкод = ДанныеОбъекта.Штрихкод;
		ТабличныйДокумент.Вывести(Область);
	КонецЕсли;
	
	Если ДанныеОбъекта.ТипКарты = ПредопределенноеЗначение("Перечисление.ТипыКарт.Магнитная")
		ИЛИ ДанныеОбъекта.ТипКарты = ПредопределенноеЗначение("Перечисление.ТипыКарт.Смешанная") Тогда
		Область = Макет.ПолучитьОбласть("МагнитныйКод");
		Область.Параметры.МагнитныйКод = ДанныеОбъекта.МагнитныйКод;
		ТабличныйДокумент.Вывести(Область);
	КонецЕсли;
	
	Область = Макет.ПолучитьОбласть("Подвал");
	Область.Параметры.ВидКарты = ДанныеОбъекта.ВидКарты;
	Область.Параметры.Организация = ДанныеОбъекта.Организация;
	ТабличныйДокумент.Вывести(Область);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
