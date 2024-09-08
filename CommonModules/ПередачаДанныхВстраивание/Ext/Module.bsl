﻿#Область СлужебныйПрограммныйИнтерфейс

// Определяет менеджеры логических хранилищ.
//
// Параметры:
//   ВсеМенеджерыЛогическихХранилищ - Соответствие из Строка - менеджеры логических хранилищ:
//    * Ключ - Строка - идентификатор логического хранилища;
//    * Значение - ОбщийМодуль - менеджер логического хранилища.
//
//@skip-check module-empty-method
Процедура МенеджерыЛогическихХранилищ(ВсеМенеджерыЛогическихХранилищ) Экспорт
		
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.МиграцияПриложений") Тогда
		МодульМиграцияПриложений = ОбщегоНазначения.ОбщийМодуль("МиграцияПриложений");
		ВсеМенеджерыЛогическихХранилищ.Вставить("migration", МодульМиграцияПриложений);
	КонецЕсли;
	
КонецПроцедуры

// Определяет менеджеры физических хранилищ.
//
// Параметры:
//   ВсеМенеджерыФизическихХранилищ - Соответствие из Строка - менеджеры физических хранилищ:
//    * Ключ - Строка - идентификатор физического хранилища;
//    * Значение - ОбщийМодуль - менеджер физического хранилища.
//
//@skip-check module-empty-method
Процедура МенеджерыФизическихХранилищ(ВсеМенеджерыФизическихХранилищ) Экспорт
	
КонецПроцедуры

// Определяет период действия временного идентификатора.
//
// Параметры:
//   ПериодДействияВременногоИдентификатора - Число - период действия временного идентификатора.
//
//@skip-check module-empty-method
Процедура ПериодДействияВременногоИдентификатора(ПериодДействияВременногоИдентификатора) Экспорт
	
КонецПроцедуры

// Определяет размер блока получения данных.
//
// Параметры:
//   РазмерБлокаПолученияДанных - Число - размер блока получения данных в байтах.
//
//@skip-check module-empty-method
Процедура РазмерБлокаПолученияДанных(РазмерБлокаПолученияДанных) Экспорт
	
КонецПроцедуры

// Определяет размер блока отправки данных.
//
// Параметры:
//   РазмерБлокаОтправкиДанных - Число - размер блока отправки данных в байтах.
//
//@skip-check module-empty-method
Процедура РазмерБлокаОтправкиДанных(РазмерБлокаОтправкиДанных) Экспорт
	
КонецПроцедуры

// Вызывается при ошибке получения данных.
//
// Параметры:
//   Ответ - HTTPСервисОтвет - ответ сервиса при получении данных.
//
//@skip-check module-empty-method
Процедура ОшибкаПриПолученииДанных(Ответ) Экспорт
	
	ОбщегоНазначенияБТС.ЗаписьТехнологическогоЖурнала("ПолучениеДанных.Ошибка", Новый Структура("КодСостояния, Описание", Ответ.КодСостояния, Ответ.ПолучитьТелоКакСтроку()));
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Передача данных.Получение'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,
		,
		,
		СтрШаблон(
			НСтр("ru = 'Код состояния: %1 %2'", ОбщегоНазначения.КодОсновногоЯзыка()),
			Ответ.КодСостояния,
			Символы.ПС + Ответ.ПолучитьТелоКакСтроку()));
	
КонецПроцедуры

// Вызывается при ошибке отправки данных.
//
// Параметры:
//   Ответ - HTTPСервисОтвет - ответ сервиса при отправке данных.
//
//@skip-check module-empty-method
Процедура ОшибкаПриОтправкеДанных(Ответ) Экспорт
	
	ОбщегоНазначенияБТС.ЗаписьТехнологическогоЖурнала("ОтправкаДанных.Ошибка", Новый Структура("КодСостояния, Описание", Ответ.КодСостояния, Ответ.ПолучитьТелоКакСтроку()));
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Передача данных.Отправка'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,
		,
		,
		СтрШаблон(
			НСтр("ru = 'Код состояния: %1 %2'", ОбщегоНазначения.КодОсновногоЯзыка()),
			Ответ.КодСостояния,
			Символы.ПС + Ответ.ПолучитьТелоКакСтроку()));
	
КонецПроцедуры

// Вызывается при получении имени временного файла.
//
// Параметры:
//   ИмяВременногоФайла - Строка - имя временного файла.
//   Расширение - Строка - желаемое расширение имени временного файла.
//   ДополнительныеПараметры - Структура - дополнительные параметры временного файла.
//
//@skip-check module-empty-method
Процедура ПриПолученииИмениВременногоФайла(ИмяВременногоФайла, Расширение) Экспорт
	
КонецПроцедуры

// Вызывается при продлении действия временного идентификатора.
//
// Параметры:
//   Идентификатор - Строка - идентификатор запроса.
//   Дата - Дата - дата регистрации запроса.
//   Запрос - Структура - исходный HTTP-запрос:
//    * HTTPМетод - Строка - HTTP-метод;
//    * БазовыйURL - Строка - базовая часть URL-запроса, включающая имя сервиса;
//    * Заголовки - ФиксированноеСоответствие из Строка - заголовки HTTP-запроса;
//    * ОтносительныйURL - Строка - относительную часть URL-адреса (относительно сервиса);
//    * ПараметрыURL - ФиксированноеСоответствие из Строка - части URL-адреса, которые были параметризованы в шаблоне;
//    * ПараметрыЗапроса - ФиксированноеСоответствие из Строка - параметры запроса (в строке URL-адреса параметры следуют после знака запроса);
//    * ИдентификаторЗапроса - Строка - уникальный идентификатор запроса;
//    * ТипЗапроса - Строка - тип запроса;
//    * ИмяВременногоФайла - Строка - имя используемого временного файла.
//
//@skip-check module-empty-method
Процедура ПриПродленииДействияВременногоИдентификатора(Идентификатор, Дата, Запрос) Экспорт

КонецПроцедуры

// Вызывается при получении Прокси, используемого для соединения с сервером.
// 
// Параметры:
//  Прокси - Неопределено, ИнтернетПрокси - Прокси, используемый для соединения с сервером.
//  СтруктураURI - Структура - поля:
//    * Схема - Строка - схема из URI
//    * Логин - Строка - логин из URI
//    * Пароль - Строка - пароль из URI
//    * Хост - Строка - хост из URI
//    * Порт - Число - порт из URI
//    * ПутьНаСервере - Строка - часть <путь>?<параметры>#<якорь> из URI
//
//@skip-check module-empty-method
Процедура ПриПолученииПрокси(Прокси, СтруктураURI) Экспорт

	Прокси = ПолучениеФайловИзИнтернета.ПолучитьПрокси(СтруктураURI.Схема);

КонецПроцедуры

#КонецОбласти