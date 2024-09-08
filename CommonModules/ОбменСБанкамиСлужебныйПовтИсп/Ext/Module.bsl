﻿////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиСлужебныйПовтИсп: механизм обмена электронными документами с банками.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Заполняет массив актуальными видами электронных документов.
//
// Возвращаемое значение:
//  Массив - виды актуальных ЭД.
//
Функция АктуальныеВидыЭД() Экспорт
	
	МассивЭД = Новый Массив;
	ОбменСБанкамиПереопределяемый.ПолучитьАктуальныеВидыЭД(МассивЭД);
	
	МассивЭД.Добавить(Перечисления.ВидыЭДОбменСБанками.ЗапросНаОтзывЭД);
	
	// Служебные виды ЭД требуются для добавления в сертификат
	МассивЭД.Добавить(Перечисления.ВидыЭДОбменСБанками.ЗапросОСостоянииЭД);
	МассивЭД.Добавить(Перечисления.ВидыЭДОбменСБанками.ЗапросЗонд);
	
	МассивВозврата = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивЭД);
	
	Возврат МассивВозврата;
	
КонецФункции

// Возвращает список видов документов, которые могут подписываться по пользовательскому маршруту.
//
// Параметры:
//  ТолькоСоСложнымМаршрутом - Булево - если Истина, будут возвращены только те виды, которым можно назначить маршрут
//                                      со сложными правилами подписания.
// 
// Возвращаемое значение:
//  Массив - содержит элементы типа "Перечисление.ВидыЭДОбменСБанками".
//
Функция ВидыДокументовПодписываемыхПоМаршруту(ТолькоСоСложнымМаршрутом = Истина) Экспорт

	Результат = ОбменСБанкамиСлужебный.ВидыДокументовПодписываемыхПоМаршруту();
	Если ТолькоСоСложнымМаршрутом Тогда
		
		ИндексЗапросНаОтзывЭД = Результат.Найти(Перечисления.ВидыЭДОбменСБанками.ЗапросНаОтзывЭД);
		Если ИндексЗапросНаОтзывЭД <> Неопределено Тогда
			Результат.Удалить(ИндексЗапросНаОтзывЭД);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Возвращает текст программы с указанием версии, используемой для обмена с банком.
//
// Параметры:
//  КоличествоСимволов - Число - ограничение на количество символов по версии программы, по умолчанию 100.
//
// Возвращаемое значение:
//  Строка - текст программы с указанием версии.
//
Функция ВерсияПрограммыКлиентаДляБанка(КоличествоСимволов = 100) Экспорт
	
	ВерсияПрограммы = СтрШаблон(НСтр("ru = '1С - БЭД: %1; %2: %3'"),
		ОбновлениеИнформационнойБазыБЭД.ВерсияБиблиотеки(),
		Метаданные.Имя,
		Метаданные.Версия);

	Если КоличествоСимволов > 0 Тогда
		ВерсияПрограммы = Лев(ВерсияПрограммы, КоличествоСимволов);
	КонецЕсли;
	
	Возврат СокрЛП(ВерсияПрограммы);
	
КонецФункции

// Возвращает данные по банкам, поддерживающих прямой обмен.
//
// Возвращаемое значение:
//   ТабличныйДокумент - содержит данные по банкам.
//
Функция СписокБанков() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИспользуетсяТестовыйРежим = Ложь;
	ОбменСБанкамиПереопределяемый.ПроверитьИспользованиеТестовогоРежима(ИспользуетсяТестовыйРежим);
	
	Если ИспользуетсяТестовыйРежим Тогда
		Макет = Справочники.НастройкиОбменСБанками.ПолучитьМакет("СписокБанковВТестовомРежиме");
		Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;
	Иначе
		ДанныеВнешнихФайлов = Константы.ОбщиеФайлыОбменСБанками.Получить().Получить();
		Если ДанныеВнешнихФайлов = Неопределено ИЛИ НЕ ДанныеВнешнихФайлов.Свойство("СписокБанков")
				ИЛИ ДанныеВнешнихФайлов.СписокБанков = Неопределено Тогда  // список еще не подкачивался из интернета
			Макет = Справочники.НастройкиОбменСБанками.ПолучитьМакет("СписокБанков");
			Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;
		Иначе
			Попытка
				ВремФайл = ПолучитьИмяВременногоФайла("mxl");
				ДанныеВнешнихФайлов.СписокБанков.Записать(ВремФайл);
				Макет = Новый ТабличныйДокумент;
				Макет.Прочитать(ВремФайл);
				ФайловаяСистема.УдалитьВременныйФайл(ВремФайл);
			Исключение
				// Если не удалось прочитать файл, то берем список из конфигурации
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ВидОперации = НСтр("ru = 'Чтение списка банков сервиса 1С:ДиректБанк из скачанного файла.'");
				ЭлектронноеВзаимодействие.ОбработатьОшибку(ВидОперации, ТекстОшибки, , "ОбменСБанками");
				Макет = Справочники.НастройкиОбменСБанками.ПолучитьМакет("СписокБанков");
				Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;

	Возврат Макет;
	
КонецФункции

// Получение фабрики XDTO в соответствии с версией схемы асинхронного обмена.
//
// Параметры:
//  ВерсияФормата - Строка - версия схемы.
// 
// Возвращаемое значение:
//  ФабрикаXDTO - фабрика, созданная на основании схемы.
//
Функция ФабрикаAsyncXDTO(ВерсияФормата) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВерсииСхемАсинхронногоОбмена = ОбменСБанкамиСлужебный.ВерсииСхемАсинхронногоОбмена();
	ТекущаяСхема = ВерсииСхемАсинхронногоОбмена.Получить(ВерсияФормата);
	
	// Если версия схемы не известна конфигурации, то идет попытка чтения по актуальной версии
	Если ТекущаяСхема = Неопределено Тогда
		ВерсияФормата = ОбменСБанкамиКлиентСервер.АктуальнаяВерсияФорматаАсинхронногоОбмена();
		ТекущаяСхема = ВерсииСхемАсинхронногоОбмена.Получить(ВерсияФормата);
	КонецЕсли;
	
	ДвоичныеДанныеСхемы = Обработки.ОбменСБанками.ПолучитьМакет(ТекущаяСхема);
	ВремФайлСхемы = ПолучитьИмяВременногоФайла("xsd");
	ДвоичныеДанныеСхемы.Записать(ВремФайлСхемы);
	Фабрика = СоздатьФабрикуXDTO(ВремФайлСхемы);
	ФайловаяСистема.УдалитьВременныйФайл(ВремФайлСхемы);
	Возврат Фабрика;
	
КонецФункции

// Создает объект для обмена с сервером Сбербанка
// 
// Возвращаемое значение:
// WSПрокси - Клиентский прокси для вызова веб-сервиса.
//
Функция WSПроксиСбербанк(Таймаут = 30) Экспорт
	
	URI = "http://upg.sbns.bssys.com/";
	ИмяСервиса = "UniversalPaymentGate";
	ИмяТочкиПодключения = "UniversalPaymentGateSbrfImplPort";
	
	ИспользуетсяТестовыйРежим = Ложь;
	ОбменСБанкамиПереопределяемый.ПроверитьИспользованиеТестовогоРежима(ИспользуетсяТестовыйРежим);
	Если ИспользуетсяТестовыйРежим Тогда
		Местоположение = "https://edupirsms.testsbi.sberbank.ru:9443/sbns-upg/upg";
	КонецЕсли;
	
	ИменаЦепочекСертификатов = Новый Массив;
	ИменаЦепочекСертификатов.Добавить(""); // По умолчанию из операционной системы
	ИменаЦепочекСертификатов.Добавить("russian_trusted_ca"); // УЦ Минцифры
	ИменаЦепочекСертификатов.Добавить("sberca"); // УЦ Сбербанка
	
	Прокси = ИнтернетСоединениеБЭД.СформироватьПрокси("https");
	
	Для каждого ИмяЦепочкиСертификатов Из ИменаЦепочекСертификатов Цикл
	
		ЗащищенноеСоединение = СоздатьЗащищенноеСоединение(ИмяЦепочкиСертификатов);
		WSОпределениеСбербанк = СоздатьWSОпределениеСбербанк(ЗащищенноеСоединение);
		WSПрокси = Новый WSПрокси(
			WSОпределениеСбербанк,
			URI,
			ИмяСервиса,
			ИмяТочкиПодключения,
			Прокси,
			Таймаут,
			ЗащищенноеСоединение,
			Местоположение);
		
		УзелПрошелПроверку = Истина;
		ОшибкаИнтернетСоединения = Ложь;
		
		ЗапросАутентификацииТип = WSПрокси.ФабрикаXDTO.Тип("http://upg.sbns.bssys.com/", "preLogin");
		ЗначениеXDTO = WSПрокси.ФабрикаXDTO.Создать(ЗапросАутентификацииТип);
		Попытка
			// Вызываем метод сервиса preLogin, чтобы проверить корректность подключения.
			// Если при вызове метода выдается исключение с текстом про Узел или certification,
			// значит подключение по сертификатам ОС не удалось и повторяем попытку подключения
			// с сертификатами из макета.
			WSПрокси.preLogin(ЗначениеXDTO);
		Исключение
			КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстОшибки1 = "Удаленный узел не прошел проверку";
			ТекстОшибки2 = "Trust anchor for certification path not found";
			Если СтрНайти(КраткоеПредставлениеОшибки, ТекстОшибки1) > 0
				Или СтрНайти(КраткоеПредставлениеОшибки, ТекстОшибки2) > 0 Тогда
				УзелПрошелПроверку = Ложь;
			КонецЕсли;
			ОшибкаИнтернетСоединения = ЗначениеЗаполнено(
				ОбменСБанкамиСлужебныйКлиентСервер.ТипОшибкиИнтернетСоединения(КраткоеПредставлениеОшибки));
		КонецПопытки;
	
		Если ОшибкаИнтернетСоединения ИЛИ УзелПрошелПроверку Тогда
			// Выходим из цикла сразу, как найдем подходящую цепочку сертификатов,
			// или обнаружим ошибку, не связанную с сертификатами.
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
		
	Результат = Новый Структура;
	Результат.Вставить("WSПрокси", WSПрокси);
	Результат.Вставить("ТекстОшибкиИнтернетСоединения", "");
	Если ОшибкаИнтернетСоединения Тогда
		Результат.ТекстОшибкиИнтернетСоединения = КраткоеПредставлениеОшибки;	
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

// Определяет название счета в метаданных
// 
// Возвращаемое значение:
//  Строка - название справочника банковских счетов организации.
//
Функция НазваниеСчетаВМетаданных() Экспорт
	
	ОписаниеТипаБанковскийСчет = Метаданные.ОпределяемыеТипы.СчетОрганизацииОбменСБанками.Тип;
	ТипСчет = ОписаниеТипаБанковскийСчет.Типы().Получить(0);
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипСчет);
	Возврат ОбъектМетаданных.Имя;
	
КонецФункции

// Определяет возможность получения MAC-адреса сетевого оборудования на клиенте.
// 
// Возвращаемое значение:
//   - 
//
Функция МожноПолучитьMAC() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	МинимальнаяВерсияПлатформыДляПолученияMAC = "8.3.18.0";
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, МинимальнаяВерсияПлатформыДляПолученияMAC) > 0 Тогда
		Возврат Истина
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Определяет, нужно ли открывать ссылку банка во внешнем браузере
//
// Параметры:
//  БИК - Строка - БИК банка
//
// Возвращаемое значение:
//  Булево - Если Ложь, то открытие во внешнем браузере (по умлочанию);
//   Если Истина - открытие во встроенном в 1С браузере.
//
Функция ОткрыватьОкноПодтвержденияSMSВоВнешнемБраузере(БИК) Экспорт
	
	Возврат ОбменСБанкамиСлужебный.ОткрыватьОкноПодтвержденияSMSВоВнешнемБраузере(БИК);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоздатьWSОпределениеСбербанк(ЗащищенноеСоединение)
	
	УстановитьПривилегированныйРежим(Истина);
	ВремФайл = ПолучитьИмяВременногоФайла("wsdl");
	ДвоичныеДанные = Обработки.ОбменСБанками.ПолучитьМакет("SBRFWSDL");
	ДвоичныеДанные.Записать(ВремФайл);
	Прокси = ИнтернетСоединениеБЭД.СформироватьПрокси("https");
	WSОпределение = Новый WSОпределения(ВремФайл, , , Прокси, 15, ЗащищенноеСоединение);
	ФайловаяСистема.УдалитьВременныйФайл(ВремФайл);
	Возврат WSОпределение;
	
КонецФункции

Функция СоздатьЗащищенноеСоединение(ИмяЦепочкиСертификатов)
	
	Если ЗначениеЗаполнено(ИмяЦепочкиСертификатов) Тогда
		ИмяФайла = ПолучитьИмяВременногоФайла("pem");
		ДвоичныеДанные = Обработки.ОбменСБанками.ПолучитьМакет(ИмяЦепочкиСертификатов);
		ДвоичныеДанные.Записать(ИмяФайла);
		
		Сертификаты = Новый СертификатыУдостоверяющихЦентровФайл(ИмяФайла);
		ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение(Неопределено, Сертификаты);
		ФайловаяСистема.УдалитьВременныйФайл(ИмяФайла);
	Иначе
		СертификатыУдостоверяющихЦентров = Новый СертификатыУдостоверяющихЦентровОС;
		ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение(
			,
			СертификатыУдостоверяющихЦентров);
	КонецЕсли;
	
	Возврат ЗащищенноеСоединение;
	
КонецФункции

#КонецОбласти