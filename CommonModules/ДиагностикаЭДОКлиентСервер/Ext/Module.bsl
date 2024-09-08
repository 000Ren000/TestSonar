﻿////////////////////////////////////////////////////////////////////////////////
// ДиагностикаЭДОКлиентСервер: механизм диагностики обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Формирует параметры выполнения диагностики.
// 
// Возвращаемое значение:
//  Структура - со свойствами:
//     * ВидыДиагностики        - Массив из Строка - виды диагностики, которые нужно выполнить. Если не заполнен, то выполняются
//                                  все виды диагностики. См. область ВидыДиагностики общего
//                                  модуля ДиагностикаЭДОКлиентСервер.
//     * ОповещениеОЗавершении  - ОписаниеОповещения - Если не задан, будет выполняться стандартная
//                                  обработка - открытие формы мастера диагностики электронного документооборота.
//                                  Содержит описание процедуры, которая будет вызвана после завершения диагностики
//                                  со следующими параметрами:
//          ** РезультатДиагностики - Структура - с ключами:
//                                     * Результат - Булево - истина, если все виды диагностики выполнены успешно.
//                                     * Результаты - Структура - результаты диагностики:
//                                       ** Ключ - Строка - вид диагностики.
//                                       ** Значение - Структура - результат вида диагностики, см. ДиагностикаЭДОСлужебный.НовыйРезультатВидаДиагностики
//          ** ДополнительныеПараметры - Произвольный - значение, которое было указано при создании.
//                                  объекта ОписаниеОповещения.
//     * Отбор  - Структура - со свойствами:
//        * Сертификат - Массив из СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - сертификаты,
//                                по которым нужно выполнить диагностику.
//        * УчетнаяЗапись - Массив из Строка - идентификаторы учетных записей, по которым нужно выполнить диагностику.
//     * ПояснениеФормыВводаПароляСертификата - Строка - выводится в форму ввода пароля сертификата.
//     * ДополнительныеСертификатыДляПроверки - Массив из СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - заполняется,
//                                              если необходимо дополнительно проверить сертификаты, непривязанные к учетным записям.
//
Функция НовыеПараметрыВыполненияДиагностики() Экспорт
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("ВидыДиагностики", Новый Массив);
	ПараметрыВыполнения.Вставить("ОповещениеОЗавершении", Неопределено);
	ПараметрыВыполнения.Вставить("ПояснениеФормыВводаПароляСертификата", "");
	ПараметрыВыполнения.Вставить("ДополнительныеСертификатыДляПроверки", Новый Массив);
	
	Отбор = Новый Структура;
	Отбор.Вставить("Сертификат", Новый Массив);
	Отбор.Вставить("УчетнаяЗапись", Новый Массив);
	
	ПараметрыВыполнения.Вставить("Отбор", Отбор);
	
	ДобавитьСлужебныеПараметрыВыполненияДиагностики(ПараметрыВыполнения);
	
	Возврат ПараметрыВыполнения;
	
КонецФункции

Функция ЕстьОшибки(КонтекстДиагностики) Экспорт
	
	Возврат ОбработкаНеисправностейБЭДКлиентСервер.ПолучитьОшибки(КонтекстДиагностики).Количество() > 0;
	
КонецФункции

Функция ОшибкиДиагностируются(Ошибки, ВидыДиагностики) Экспорт
	
	Для Каждого Ошибка Из Ошибки Цикл
		Если ОбработкаНеисправностейБЭДКлиентСервер.ЭтоОшибкаДанногоВида(Ошибка,
			ИнтернетСоединениеБЭДКлиентСервер.ВидОшибкиИнтернетСоединение()) Тогда
			ВидыДиагностики.Добавить(ВидДиагностикиИнтернетСоединение());
		ИначеЕсли ОбработкаНеисправностейБЭДКлиентСервер.ЭтоОшибкаДанногоВида(Ошибка,
			КриптографияБЭДКлиентСервер.ВидОшибкиКриптография()) Тогда
			ВидыДиагностики.Добавить(ВидДиагностикиКриптография());
		ИначеЕсли ОбработкаНеисправностейБЭДКлиентСервер.ЭтоОшибкаДанногоВида(Ошибка,
			ИнтеграцияБИПБЭДКлиентСервер.ВидОшибкиИнтернетПоддержка()) Тогда
			ВидыДиагностики.Добавить(ВидДиагностикиИнтернетПоддержка());
		ИначеЕсли ОбработкаНеисправностейБЭДКлиентСервер.ЭтоОшибкаДанногоВида(Ошибка,
			РаботаСФайламиБЭДКлиентСервер.ВидОшибкиРаботаСФайлами()) Тогда
			ВидыДиагностики.Добавить(ВидДиагностикиРаботаСФайлами());
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВидыДиагностики.Количество() > 0;
	
КонецФункции

#Область ВидыДиагностики

// Возвращает идентификатор вида диагностики интернет-соединения.
// 
// Возвращаемое значение:
//  Строка - вид диагностики.
//
Функция ВидДиагностикиИнтернетСоединение() Экспорт
	
	Возврат "ИнтернетСоединение";
	
КонецФункции

// Возвращает идентификатор вида диагностики криптографии.
// 
// Возвращаемое значение:
//  Строка - вид диагностики.
//
Функция ВидДиагностикиКриптография() Экспорт
	
	Возврат "Криптография";
	
КонецФункции

// Возвращает идентификатор вида диагностики интернет-поддержки.
// 
// Возвращаемое значение:
//  Строка - вид диагностики.
//
Функция ВидДиагностикиИнтернетПоддержка() Экспорт
	
	Возврат "ИнтернетПоддержка";
	
КонецФункции

// Возвращает идентификатор вида диагностики работы с файлами.
// 
// Возвращаемое значение:
//  Строка - вид диагностики.
//
Функция ВидДиагностикиРаботаСФайлами() Экспорт
	
	Возврат "РаботаСФайлами";
	
КонецФункции

// Возвращает идентификатор вида диагностики теста аутентификации.
// 
// Возвращаемое значение:
//  Строка - вид диагностики.
//
Функция ВидДиагностикиТестАутентификации() Экспорт
	
	Возврат "ТестАутентификации";
	
КонецФункции

#КонецОбласти

#Область ВидыОшибок

// Возвращаемое значение:
//  Строка
Функция ВидОшибкиОтправкиИПолученияНетДоступныхСертификатов() Экспорт
	
	Возврат "НетДоступныхСертификатов";
	
КонецФункции

// Возвращаемое значение:
//  Строка
Функция ВидОшибкиОтправкиИПолученияНетДоступаКСертификатам() Экспорт
	
	Возврат "НетДоступаКСертификатам";
	
КонецФункции

Функция НовыеДополнительныеСвойстваОшибки(ВидОшибки = Неопределено) Экспорт
	
	ДополнительныеСвойства = Новый Структура;
	ДополнительныеСвойства.Вставить("ДанныеДляФормированияФайловДляТехподдержки", Новый Массив);
	ДополнительныеСвойства.Вставить("ТекстСообщения",                             "");
	ДополнительныеСвойства.Вставить("Приглашение",                                Неопределено);
	ДополнительныеСвойства.Вставить("ИдентификаторДокумента",                     "");
	ДополнительныеСвойства.Вставить("ПредставлениеНенастроеннойСвязи",            "");
	
	Возврат ДополнительныеСвойства;
	
КонецФункции

#КонецОбласти

#Область ОбработкаРезультатовОтправкиПолучения

Функция НовоеОписаниеОбработаннойУчетнойЗаписи(Идентификатор = "") Экспорт
	
	ОбработаннаяУчетнаяЗапись = Новый Структура;
	ОбработаннаяУчетнаяЗапись.Вставить("Идентификатор", Идентификатор);
	ОбработаннаяУчетнаяЗапись.Вставить("ОтправкаПолучениеВыполнялись", Ложь);
	ОбработаннаяУчетнаяЗапись.Вставить("ПользовательОтказалсяОтОперации", Ложь);
	ОбработаннаяУчетнаяЗапись.Вставить("ИнформацияОбОшибке", НоваяИнформацияОбОшибке());
	
	Возврат ОбработаннаяУчетнаяЗапись;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Функция ОписаниеМенеджераКриптографииWindows() Экспорт
	
	Описание = Новый Структура; 
	Описание.Вставить("ИмяПрограммы", "Microsoft Enhanced Cryptographic Provider v1.0");
	Описание.Вставить("ТипПрограммы", 1);
	Описание.Вставить("ПутьКПрограмме", "");
	
	Возврат Описание;
	
КонецФункции

Функция ДобавитьСлужебныеПараметрыВыполненияДиагностики(ОсновныеПараметры)
	
	СлужебныеПараметры = Новый Структура;
	СлужебныеПараметры.Вставить("Ошибки", Новый Массив);
	СлужебныеПараметры.Вставить("РезультатДиагностики", Неопределено);
	СлужебныеПараметры.Вставить("ПараметрыОткрытияМастера", Неопределено);
	СлужебныеПараметры.Вставить("ПараметрыФормы", Новый Структура);
	СлужебныеПараметры.Вставить("ОткрыватьОкноДиагностики", Ложь);
	СлужебныеПараметры.Вставить("ДлительнаяОперация", Неопределено);
	СлужебныеПараметры.Вставить("РезультатыПолученияОтпечатков",
		КриптографияБЭДКлиентСервер.НовыеРезультатыПолученияОтпечатков());
	СлужебныеПараметры.Вставить("ЕстьКриптографияНаСервере", Ложь);
	СлужебныеПараметры.Вставить("ЕстьКриптографияНаКлиенте", Ложь);
	СлужебныеПараметры.Вставить("ЕстьМенеджерКриптографииНаКлиенте", Ложь);
	СлужебныеПараметры.Вставить("ЕстьМенеджерКриптографииНаСервере", Ложь);
	СлужебныеПараметры.Вставить("СертификатыСУстановленнымиПаролями", Новый Массив);
	СлужебныеПараметры.Вставить("ВидыПроверок", Новый Массив);
	СлужебныеПараметры.Вставить("ИнформационнаяБазаФайловая", Неопределено);
	СлужебныеПараметры.Вставить("ИмяКомпьютераКлиент", "");
	СлужебныеПараметры.Вставить("ИмяКомпьютераСервер", "");
	СлужебныеПараметры.Вставить("ДиагностикаРаботыСФайламиВРежимеОтображенияРезультата", Ложь);
	СлужебныеПараметры.Вставить("ЗамерДиагностикиНаКлиенте", Неопределено);
	// В веб-клиенте проверки сертификатов выполняются только при запуске диагностики через общую команду "Диагностика ЭДО"
	// или при выполнении повторной диагностики (кнопка "Повторить диагностику" в форме ДиагностикаЭДО).
	СлужебныеПараметры.Вставить("ВыполнятьПроверкиСертификатовВВебКлиенте", Ложь);
	СлужебныеПараметры.Вставить("КлючиСинхронизации", СинхронизацияЭДОКлиентСервер.НовыеКлючиСинхронизации());
	СлужебныеПараметры.Вставить("СертификатыДляПроверки", Новый Массив);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ОсновныеПараметры, СлужебныеПараметры, Ложь);
	
	Возврат ОсновныеПараметры;
	
КонецФункции

Функция ЕстьВидДиагностики(ВидыДиагностики, Вид) Экспорт 
	
	Возврат ВидыДиагностики.Количество() = 0 Или ВидыДиагностики.Найти(Вид) <> Неопределено;
	
КонецФункции

Функция ПредставлениеОшибок(Ошибки) Экспорт
	
	ВидыДиагностики = Новый Массив;
	ОшибкиДиагностируются(Ошибки, ВидыДиагностики);
	ПредставленияОшибок = Новый Массив;
	Для каждого ВидДиагностики Из ВидыДиагностики Цикл
		ПредставлениеОшибки = ПолучитьСклонение(ВидДиагностики, "Творительный");
		Если ПредставленияОшибок.Найти(ПредставлениеОшибки) = Неопределено Тогда
			ПредставленияОшибок.Добавить(ПредставлениеОшибки);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрСоединить(ПредставленияОшибок, ", ");
	
КонецФункции

Процедура ДобавитьСклонение(Склонения, Строка, Падеж, Значение) 
	
	Склонение = Склонения.Получить(Строка);
	Если Склонение = Неопределено Тогда
		Склонение = Новый Структура;
	КонецЕсли;
	Склонение.Вставить(Падеж, Значение);
	Склонения.Вставить(Строка, Склонение);
	
КонецПроцедуры

Функция РезультатВидаДиагностики(РезультатДиагностики, ВидДиагностики) Экспорт
	
	РезультатВидаДиагностики = Неопределено; 
	РезультатДиагностики.Результаты.Свойство(ВидДиагностики, РезультатВидаДиагностики);
	
	Возврат РезультатВидаДиагностики; 
	
КонецФункции

Функция ПолучитьСклонение(Строка, Падеж) Экспорт
	
	Склонения = Новый Соответствие;
	ДобавитьСклонение(Склонения, ВидДиагностикиИнтернетСоединение(), "Творительный", НСтр("ru = 'интернет-соединением'"));
	ДобавитьСклонение(Склонения, ВидДиагностикиИнтернетСоединение(), "Родительный", НСтр("ru = 'интернет-соединения'"));
	
	ДобавитьСклонение(Склонения, ВидДиагностикиКриптография(), "Творительный", НСтр("ru = 'криптографией'"));
	ДобавитьСклонение(Склонения, ВидДиагностикиКриптография(), "Родительный", НСтр("ru = 'криптографии'"));
	
	ДобавитьСклонение(Склонения, ВидДиагностикиИнтернетПоддержка(), "Творительный", НСтр("ru = 'интернет-поддержкой'"));
	ДобавитьСклонение(Склонения, ВидДиагностикиИнтернетПоддержка(), "Родительный", НСтр("ru = 'интернет-поддержки'"));
	
	ДобавитьСклонение(Склонения, ВидДиагностикиРаботаСФайлами(), "Творительный", НСтр("ru = 'работой с файлами'"));
	ДобавитьСклонение(Склонения, ВидДиагностикиРаботаСФайлами(), "Родительный", НСтр("ru = 'работы с файлами'"));
	
	ДобавитьСклонение(Склонения, ВидДиагностикиТестАутентификации(), "Творительный", НСтр("ru = 'тестом аутентификации'"));
	ДобавитьСклонение(Склонения, ВидДиагностикиТестАутентификации(), "Родительный", НСтр("ru = 'теста аутентификации'"));
	
	Склонение = Склонения.Получить(Строка);
	Если Склонение = Неопределено Тогда
		Возврат Неопределено; 
	КонецЕсли;
	
	Значение = Неопределено;
	Склонение.Свойство(Падеж, Значение);
	
	Возврат Значение;
	
КонецФункции

Функция НоваяИнформацияОбОшибке()
	
	ИнформацияОбОшибке = Новый Структура;
	ИнформацияОбОшибке.Вставить("ВидОшибки", "НеизвестнаяОшибка");
	ИнформацияОбОшибке.Вставить("КраткоеПредставление", "");
	
	ПодробноеПредставление = Новый Структура;
	ПодробноеПредставление.Вставить("Текст", "");
	ПодробноеПредставление.Вставить("ОбработчикиНажатия", Новый Соответствие);
	ИнформацияОбОшибке.Вставить("ПодробноеПредставление", ПодробноеПредставление);
	
	Возврат ИнформацияОбОшибке;
	
КонецФункции

Функция СкрыватьРезультатТестаАутентификации(РезультатДиагностики) Экспорт
	
	Возврат ТолькоУчетныеЗаписиПрямогоОбмена(РезультатДиагностики);
	
КонецФункции 

Функция ТолькоУчетныеЗаписиПрямогоОбмена(РезультатДиагностики)
	
	Результат = Истина;
	Для каждого ДанныеУчетнойЗаписи Из РезультатДиагностики.ДанныеУчетныхЗаписей Цикл
		Если Не ДанныеУчетнойЗаписи.Значение.ЭтоПрямойОбмен Тогда
			Результат = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьРезультатПроверкиКорневыхСертификатовГУЦ(НаличиеКорневогоСертификатаГУЦ) Экспорт
	
	ВсеКорневыеСертификатыУстановлены = Истина;
	Для каждого ОписаниеСертификата Из НаличиеКорневогоСертификатаГУЦ.Сертификаты Цикл
		Если ОписаниеСертификата.Результат <> Истина Тогда
			ВсеКорневыеСертификатыУстановлены = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НаличиеКорневогоСертификатаГУЦ.Сертификаты.Количество() Тогда
		НаличиеКорневогоСертификатаГУЦ.Результат = ВсеКорневыеСертификатыУстановлены;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
