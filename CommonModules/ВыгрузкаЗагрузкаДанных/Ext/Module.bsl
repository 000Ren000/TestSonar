﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Выгрузка загрузка данных".
//
////////////////////////////////////////////////////////////////////////////////

// Данный модуль содержит интерфейсные процедуры функции
// вызова процессов выгрузки и загрузки данных.


#Область ПрограммныйИнтерфейс

// Выгружает данные в zip-архив, из которого они в дальнейшем могут быть загружены
//  в другую информационную базу или область данных с помощью функции
//  ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеТекущейОбластиИзАрхива().
//
// Параметры:
//  ПараметрыВыгрузки - Структура - содержащая параметры выгрузки данных:
//		* ВыгружаемыеТипы - Массив из ОбъектМетаданных - данные которых требуется выгрузить в архив
//      * ВыгружатьПользователей - Булево - выгружать информацию о пользователях информационной базы,
//      * ВыгружатьНастройкиПользователей - Булево - игнорируется если ВыгружатьПользователей = Ложь.
//    Также структура может содержать дополнительные ключи, которые могут быть обработаны внутри
//      произвольных обработчиков выгрузки данных.
//
// Возвращаемое значение:		
//  Структура - с полями:
//  * ИмяФайла - Строка - имя файла архива
//  * Предупреждения - Массив Из Строка - предупреждения пользователю по результатам выгрузки.
//
Функция ВыгрузитьДанныеТекущейОбластиВАрхив(Знач ПараметрыВыгрузки) Экспорт
	
	Если Не ПроверитьНаличиеПрав() Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа для выгрузки данных'");
	КонецЕсли;
	
	Если Не ПараметрыВыгрузки.Свойство("ВыгружаемыеТипы") Тогда
		ПараметрыВыгрузки.Вставить("ВыгружаемыеТипы", Новый Массив());
	КонецЕсли;
	
	Если Не ПараметрыВыгрузки.Свойство("ВыгружаемыеТипыОбщихДанных") Тогда
		ПараметрыВыгрузки.Вставить("ВыгружаемыеТипыОбщихДанных", Новый Массив());
	КонецЕсли;
	
	Если Не ПараметрыВыгрузки.Свойство("ВыгружатьПользователей") Тогда
		ПараметрыВыгрузки.Вставить("ВыгружатьПользователей", Ложь);
	КонецЕсли;
	
	Если Не ПараметрыВыгрузки.Свойство("ВыгружатьНастройкиПользователей") Тогда
		ПараметрыВыгрузки.Вставить("ВыгружатьНастройкиПользователей", Ложь);
	КонецЕсли;
	
	Если Не ПараметрыВыгрузки.Свойство("ВыгружатьЗарегистрированныеИзмененияДляУзловПланаОбмена") Тогда
		ПараметрыВыгрузки.Вставить("ВыгружатьЗарегистрированныеИзмененияДляУзловПланаОбмена", Ложь);
	КонецЕсли;
	
	Если Не ПараметрыВыгрузки.Свойство("КоличествоПотоков") Тогда
		ПараметрыВыгрузки.Вставить("КоличествоПотоков", 0);
	КонецЕсли;
			
	Если ПараметрыВыгрузки.КоличествоПотоков < 1 Тогда
		ПараметрыВыгрузки.КоличествоПотоков = 1;
	КонецЕсли;
	
	Если Не ПараметрыВыгрузки.Свойство("ПропуститьПроверкуВыгружаемыхДанных") Тогда
		
		ОшибкиВыгружаемыхДанных = ОшибкиВыгружаемыхДанных(
 			ПараметрыВыгрузки.ВыгружаемыеТипы,
 			ПараметрыВыгрузки.ВыгружаемыеТипыОбщихДанных);

		Если ЗначениеЗаполнено(ОшибкиВыгружаемыхДанных) Тогда

			ЧастиТекстаОшибки = Новый Массив;
			ЧастиТекстаОшибки.Добавить(НСтр("ru = 'Обнаруженные ошибки:'"));
			ЧастиТекстаОшибки.Добавить(Символы.ПС);

			Для Каждого ОшибкаВыгружаемыхДанных Из ОшибкиВыгружаемыхДанных Цикл
				ЧастиТекстаОшибки.Добавить("● ");
				ЧастиТекстаОшибки.Добавить(ОшибкаВыгружаемыхДанных);
				ЧастиТекстаОшибки.Добавить(Символы.ПС);
			КонецЦикла;

			ТекстОшибки = СтрСоединить(ЧастиТекстаОшибки);

			ЗаписьЖурналаРегистрации(НСтр("ru = 'Выгрузка данных. Обнаружены ошибки в выгружаемых данных'",
				ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, , , ТекстОшибки);

			Если Не РаботаВМоделиСервиса.РазделениеВключено() Тогда
				ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Перед исправлением рекомендуется создать резервную копию информационной базы средствами СУБД.
					 |
					 |%1'"), ТекстОшибки);
			КонецЕсли;
			
			ВызватьИсключение ТекстОшибки;

		КонецЕсли;
		
	КонецЕсли;
		
	Возврат ВыгрузкаЗагрузкаДанныхСлужебный.ВыгрузитьДанныеТекущейОбластиВАрхив(ПараметрыВыгрузки);
	
КонецФункции

// Загружает данные из zip архива с XML файлами.
//
// Параметры:
//  ИмяАрхива - Строка, УникальныйИдентификатор, Структура - имя файла, идентификатор файла или данные файла полученные с помощью ZipАрхивы.ПрочитатьАрхив().
//  ПараметрыЗагрузки - Структура - содержащая параметры загрузки данных:
//		* ЗагружаемыеТипы - Массив Из ОбъектМетаданных - массив объектов метаданных, данные
//        	которых требуется загрузить из архива. Если значение параметра задано - все прочие
//        	данные, содержащиеся в файле выгрузки, загружены не будут. Если значение параметра
//        	не задано - будут загружены все данные, содержащиеся в файле выгрузки.
//      * ЗагружатьПользователей - Булево - загружать информацию о пользователях информационной базы,
//      * ЗагружатьНастройкиПользователей - Булево - игнорируется, если ЗагружатьПользователей = Ложь.
//      * СопоставлениеПользователей - ТаблицаЗначений - таблица с колонками:
//        ** Пользователь - СправочникСсылка.Пользователи - идентификатора пользователя из архива.
//        ** ИдентификаторПользователяСервиса - УникальныйИдентификатор - идентификатор пользователя сервиса.
//        ** СтароеИмяПользователяИБ - Строка - старое имя пользователя базы.
//        ** НовоеИмяПользователяИБ - Строка - новое имя пользователя базы.
//    Также структура может содержать дополнительные ключи, которые могут быть обработаны внутри
//      произвольных обработчиков загрузки данных.
//
// Возвращаемое значение:		
//  Структура - с полями:
//  * Предупреждения - Массив Из Строка - предупреждения пользователю по результатам загрузки.
//
Функция ЗагрузитьДанныеТекущейОбластиИзАрхива(Знач ИмяАрхива, Знач ПараметрыЗагрузки) Экспорт
	
	Если Не ПроверитьНаличиеПрав() Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа для загрузки данных'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВнешнийМонопольныйРежим = МонопольныйРежим();
	ИспользоватьМногопоточность = ВыгрузкаЗагрузкаДанныхСлужебный.ИспользоватьМногопоточность(ПараметрыЗагрузки);
	
	Попытка
		
		Если Не ВнешнийМонопольныйРежим Тогда
			РаботаВМоделиСервиса.УстановитьМонопольнуюБлокировку(ИспользоватьМногопоточность);
		КонецЕсли;
		
		РезультатЗагрузки = ВыгрузкаЗагрузкаДанныхСлужебный.ЗагрузитьДанныеТекущейОбластиИзАрхива(
			ИмяАрхива, ПараметрыЗагрузки);
		
		Если Не ВнешнийМонопольныйРежим Тогда
			РаботаВМоделиСервиса.СнятьМонопольнуюБлокировку(ИспользоватьМногопоточность);
		КонецЕсли;
		
		Возврат РезультатЗагрузки;
		
	Исключение
		
		ТекстИсключения = ТехнологияСервиса.ПодробныйТекстОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Загрузка данных из архива'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка, , , ТекстИсключения);
		
		Если Не ВнешнийМонопольныйРежим Тогда
			РаботаВМоделиСервиса.СнятьМонопольнуюБлокировку(ИспользоватьМногопоточность);
		КонецЕсли;
		
		ВызватьИсключение ТекстИсключения;
		
	КонецПопытки;
	
КонецФункции

// Проверяет совместимость выгрузки из файла с текущей конфигурацией информационной базы.
//
// Параметры:
//  ИмяАрхива - Строка - путь к файлу выгрузки.
//
// Возвращаемое значение: 
//	Булево - Истина если данные из архива могут быть загружены в текущую конфигурацию.
//
Функция ВыгрузкаВАрхивеСовместимаСТекущейКонфигурацией(Знач ИмяАрхива) Экспорт
	
	Каталог = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(Каталог);
	Каталог = Каталог + ПолучитьРазделительПути();
	
	Архиватор = Новый ЧтениеZipФайла(ИмяАрхива);
	
	Попытка
		
		ЭлементОписанияВыгрузки = Архиватор.Элементы.Найти("DumpInfo.xml");
		
		Если ЭлементОписанияВыгрузки = Неопределено Тогда
			ВызватьИсключение СтрШаблон(НСтр("ru = 'В файле выгрузки отсутствует файл %1'"), "DumpInfo.xml");
		КонецЕсли;
		
		Архиватор.Извлечь(ЭлементОписанияВыгрузки, Каталог, РежимВосстановленияПутейФайловZIP.Восстанавливать);
		
		ФайлОписанияВыгрузки = Каталог + "DumpInfo.xml";
		
		ИнформацияОВыгрузке = ВыгрузкаЗагрузкаДанныхСлужебный.ПрочитатьОбъектXDTOИзФайла(
			ФайлОписанияВыгрузки, ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1", "DumpInfo"));
		
		Результат = ВыгрузкаЗагрузкаДанныхСлужебный.ВыгрузкаВАрхивеСовместимаСТекущейКонфигурацией(ИнформацияОВыгрузке)
			И ВыгрузкаЗагрузкаДанныхСлужебный.ВыгрузкаВАрхивеСовместимаСТекущейВерсиейКонфигурации(ИнформацияОВыгрузке);
		
		УдалитьФайлы(Каталог);
		Архиватор.Закрыть();
		
		Возврат Результат;
		
	Исключение
		
		ТекстИсключения = ТехнологияСервиса.ПодробныйТекстОшибки(ИнформацияОбОшибке());
		
		УдалитьФайлы(Каталог);
		Архиватор.Закрыть();
		
		ВызватьИсключение ТекстИсключения;
		
	КонецПопытки;
	
КонецФункции

// Записывает объект в файл.
//
// Параметры:
//	Объект - Произвольный - записываемый объект.
//	ИмяФайла - Строка - путь к файлу.
//	Сериализатор - СериализаторXDTO - сериализатор.
//
Процедура ЗаписатьОбъектВФайл(Знач Объект, Знач ИмяФайла, Сериализатор = Неопределено) Экспорт
	
	ПотокЗаписи = Новый ЗаписьXML();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла);
	
	ВыгрузкаЗагрузкаДанныхСлужебный.ЗаписатьОбъектВПоток(Объект, ПотокЗаписи, Сериализатор);
	
	ПотокЗаписи.Закрыть();
	
КонецПроцедуры

// Возвращает объект из файла.
//
// Параметры:
//	ИмяФайла - Строка - путь к файлу.
//
// Возвращаемое значение:
//	Произвольный - объект содержащий прочитанные данные
//
Функция ПрочитатьОбъектИзФайла(Знач ИмяФайла) Экспорт
	
	ПотокЧтения = Новый ЧтениеXML();
	ПотокЧтения.ОткрытьФайл(ИмяФайла);
	ПотокЧтения.ПерейтиКСодержимому();
	
	Объект = ВыгрузкаЗагрузкаДанныхСлужебный.ПрочитатьОбъектИзПотока(ПотокЧтения);
	
	ПотокЧтения.Закрыть();
	
	Возврат Объект;
	
КонецФункции

#Область ОбработкаСсылокНаТипыИсключаемыеИзВыгрузки

// Дополняет массив типов исключаемых из выгрузки-загрузки
// Предназначен для использования в обработчиках ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
//
// Параметры:
// 	Типы - Массив из ФиксированнаяСтруктура
//	Тип - ОбъектМетаданных - объект метаданных исключаемый из выгрузки-загрузки
//	ДействиеСоСсылками - Строка -  вариант действия при обнаружении ссылки на объект исключаемый из выгрузки
//		Поддерживаются следующие действия:
//			ВыгрузкаЗагрузкаДанных.ДействиеСоСсылкамиНеИзменять() - не будет произведено никаких действий  
//			ВыгрузкаЗагрузкаДанных.ДействиеСоСсылкамиОчищать() - будет выполнено очищение ссылки на невыгружаемый объект  
//			ВыгрузкаЗагрузкаДанных.ДействиеСоСсылкамиНеВыгружатьОбъект() - объект содержащий ссылку не будет выгружен
//		  
// Пример использования:
//  Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
//		ВыгрузкаЗагрузкаДанных.ДополнитьТипомИсключаемымИзВыгрузкиЗагрузки(
//			Типы,
//			Метаданные.Справочники.ИсторияПроверкиИКорректировкиДанныхПрисоединенныеФайлы,
//			ВыгрузкаЗагрузкаДанных.ДействиеСоСсылкамиНеВыгружатьОбъект());
//	КонецПроцедуры 
//
Процедура ДополнитьТипомИсключаемымИзВыгрузкиЗагрузки(Типы, Тип, ДействиеСоСсылками) Экспорт

	Если Не (ДействиеСоСсылками = ДействиеСоСсылкамиНеИзменять() 
		Или ДействиеСоСсылками = ДействиеСоСсылкамиОчищать() 
		Или ДействиеСоСсылками = ДействиеСоСсылкамиНеВыгружатьОбъект()) Тогда	
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Обнаружено неподдерживаемое действие ''%1'' при обнаружении ссылки на тип ''%2'' исключаемый из выгрузки'"),
			ДействиеСоСсылками,
			Тип);	
					
	КонецЕсли;
	
	ОписаниеТипа = Новый Структура("Тип, Действие", Тип, ДействиеСоСсылками);
	Типы.Добавить(
		Новый ФиксированнаяСтруктура(ОписаниеТипа))
	
КонецПроцедуры
	
// Возвращаемое значение:
//  Строка -
Функция ДействиеСоСсылкамиНеИзменять() Экспорт
	Возврат "НеИзменять";	
КонецФункции

// Возвращаемое значение:
//  Строка -
Функция ДействиеСоСсылкамиОчищать() Экспорт
	Возврат "Очищать";	
КонецФункции

// Возвращаемое значение:
//  Строка -
Функция ДействиеСоСсылкамиНеВыгружатьОбъект() Экспорт
	Возврат "НеВыгружатьОбъект";	
КонецФункции

#КонецОбласти

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ВыгрузкаЗагрузкаДанных.ВыгрузитьДанныеТекущейОбластиВАрхив
// Выгружает данные в zip-архив, из которого они в дальнейшем могут быть загружены
//  в другую информационную базу или область данных с помощью функции
//  ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеТекущейОбластиИзАрхива().
//
// Параметры:
//  ПараметрыВыгрузки - Структура - содержащая параметры выгрузки данных:
//		* ВыгружаемыеТипы - Массив из ОбъектМетаданных - массив объектов метаданных, данные которых требуется выгрузить в архив
//      * ВыгружатьПользователей - Булево - выгружать информацию о пользователях информационной базы,
//      * ВыгружатьНастройкиПользователей - Булево - игнорируется если ВыгружатьПользователей = Ложь.
//    Также структура может содержать дополнительные ключи, которые могут быть обработаны внутри
//      произвольных обработчиков выгрузки данных.
//
// Возвращаемое значение:
//	Строка - путь к файлу выгрузки.
//
Функция ВыгрузитьДанныеВАрхив(Знач ПараметрыВыгрузки) Экспорт
	
	Возврат ВыгрузитьДанныеТекущейОбластиВАрхив(ПараметрыВыгрузки).ИмяФайла;
	
КонецФункции

// Устарела. Следует использовать ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеТекущейОбластиИзАрхива
// Загружает данные из zip архива с XML файлами.
//
// Параметры:
//  ИмяАрхива - Строка - полное имя файла архива с данными,
//  ПараметрыЗагрузки - Структура - содержащая параметры загрузки данных:
//		* ЗагружаемыеТипы - Массив Из ОбъектМетаданных - массив объектов метаданных, данные
//        	которых требуется загрузить из архива. Если значение параметра задано - все прочие
//        	данные, содержащиеся в файле выгрузки, загружены не будут. Если значение параметра
//        	не задано - будут загружены все данные, содержащиеся в файле выгрузки.
//      * ЗагружатьПользователей - Булево - загружать информацию о пользователях информационной базы,
//      * ЗагружатьНастройкиПользователей - Булево - игнорируется, если ЗагружатьПользователей = Ложь.
//      * СопоставлениеПользователей - ТаблицаЗначений - таблица с колонками:
//        ** Пользователь - СправочникСсылка.Пользователи - идентификатора пользователя из архива.
//        ** ИдентификаторПользователяСервиса - УникальныйИдентификатор - идентификатор пользователя сервиса.
//        ** СтароеИмяПользователяИБ - Строка - старое имя пользователя базы.
//        ** НовоеИмяПользователяИБ - Строка - новое имя пользователя базы.
//    Также структура может содержать дополнительные ключи, которые могут быть обработаны внутри
//      произвольных обработчиков загрузки данных.
//
Процедура ЗагрузитьДанныеИзАрхива(Знач ИмяАрхива, Знач ПараметрыЗагрузки) Экспорт
	
	ЗагрузитьДанныеТекущейОбластиИзАрхива(ИмяАрхива, ПараметрыЗагрузки);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПоместитьОшибкиВыгружаемыхДанныхВоВременноеХранилище(АдресХранилища) Экспорт 
	ТипыМоделиДанных = ВыгрузкаЗагрузкаОбластейДанных.ПолучитьТипыМоделиДанныхОбласти();
	ТипыОбщихДанных = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыОбщихДанныхПоддерживающиеСопоставлениеСсылокПриЗагрузке();
	ОшибкиВыгружаемыхДанных = ОшибкиВыгружаемыхДанных(ТипыМоделиДанных, ТипыОбщихДанных);
	ПоместитьВоВременноеХранилище(ОшибкиВыгружаемыхДанных, АдресХранилища);
КонецПроцедуры

// Параметры:
// 	ТипыМоделиДанных - Массив из ОбъектМетаданных:
// 	ТипыОбщихДанных - ФиксированныйМассив из ОбъектМетаданных:
// 	
// Возвращаемое значение:
// 	Массив из Строка
Функция ОшибкиВыгружаемыхДанных(ТипыМоделиДанных, ТипыОбщихДанных) Экспорт
	
	ОшибкиВыгружаемыхДанных = Новый Массив;
	
	Запрос = Новый Запрос;
	ИнформационнаяБазаФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();

	ШаблонТекстаЗапросаПроверкаРегистратора =
	"ВЫБРАТЬ
	|	МИНИМУМ(Таблица.Регистратор) КАК Регистратор
	|ИЗ
	|	&Таблица КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор.Ссылка ЕСТЬ NULL
	|
	|ИМЕЮЩИЕ
	|	НЕ МИНИМУМ(Таблица.Регистратор) ЕСТЬ NULL";

	Для Каждого ВыгружаемыйТип Из ТипыМоделиДанных Цикл

		Если Не ОбщегоНазначенияБТС.ЭтоНаборЗаписей(ВыгружаемыйТип) 
			Или ОбщегоНазначенияБТС.ЭтоНезависимыйНаборЗаписей(ВыгружаемыйТип)
			Или ОбщегоНазначенияБТС.ЭтоНаборЗаписейПерерасчета(ВыгружаемыйТип) Тогда
			Продолжить;
		КонецЕсли;

		ПолноеИмя = ВыгружаемыйТип.ПолноеИмя();

		Запрос.Текст = СтрЗаменить(ШаблонТекстаЗапросаПроверкаРегистратора, "&Таблица", ПолноеИмя);

		Выборка = Запрос.Выполнить().Выбрать();

		Если Выборка.Следующий() И Не ЗначениеЗаполнено(Выборка.Регистратор) Тогда

			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Обнаружены отсутствующие регистраторы в таблице %1.
					 |Рекомендуется выполнить удаление записей с отсутствующими регистраторами.'"), ПолноеИмя) + " ";
			ОшибкиВыгружаемыхДанных.Добавить(ТекстОшибки);

		КонецЕсли;

	КонецЦикла;

	ШаблонТекстаЗапросаПроверкаДублированияИзмерений = 
	"ВЫБРАТЬ
	|	Истина
	|ИЗ
	|	(ВЫБРАТЬ ПЕРВЫЕ 1
	|		&ПоляТаблицы
	|	ИЗ
	|		&ТаблицаРегистра КАК ТаблицаРегистра
	|	
	|	СГРУППИРОВАТЬ ПО
	|	&ПоляТаблицы
	|	
	|	ИМЕЮЩИЕ
	|		КОЛИЧЕСТВО(*) > 1) КАК ВложенныйЗапрос";
	
	Для Каждого ТипМоделиДанных Из ТипыМоделиДанных Цикл
		
		ПолноеИмя = ТипМоделиДанных.ПолноеИмя();

		Если ОбщегоНазначенияБТС.ЭтоРегистрСведений(ТипМоделиДанных) Тогда
			
			ПроверятьДублированиеЗаписей = ИнформационнаяБазаФайловая;
			Если Не ИнформационнаяБазаФайловая Тогда
				ПроверятьДублированиеЗаписей = ТипМоделиДанных.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору
				И ТипМоделиДанных.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.ПозицияРегистратора;  
			КонецЕсли;
			
			Если Не ПроверятьДублированиеЗаписей Тогда
				Продолжить;
			КонецЕсли;
						
			Измерения = Новый Массив;
			
			Если ТипМоделиДанных.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
				
				Измерения.Добавить("ТаблицаРегистра.Период");
				
				Если ТипМоделиДанных.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.ПозицияРегистратора Тогда
					Измерения.Добавить("ТаблицаРегистра.Регистратор");				
				КонецЕсли;
				
			КонецЕсли;
			
			Для Каждого МетаданныеИзмерения Из ТипМоделиДанных.Измерения Цикл
				Измерения.Добавить("ТаблицаРегистра" + "." + МетаданныеИзмерения.Имя);
			КонецЦикла;
			
			Если Не ЗначениеЗаполнено(Измерения) Тогда
				Продолжить;
			КонецЕсли;
			
			Запрос.Текст = СтрЗаменить(ШаблонТекстаЗапросаПроверкаДублированияИзмерений, "&ТаблицаРегистра", ПолноеИмя);
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПоляТаблицы", СтрСоединить(Измерения, ", "));
			
			Если Не Запрос.Выполнить().Пустой() Тогда
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'Обнаружено дублирование данных в таблице %1.
					|Рекомендуется выполнить удаление дублирующихся записей.'"),
					ПолноеИмя) + " ";
				ОшибкиВыгружаемыхДанных.Добавить(ТекстОшибки);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла; 

	Для Каждого ТипОбщихДанных Из ТипыОбщихДанных Цикл

		Попытка
			ВыгрузкаЗагрузкаНеразделенныхДанных.ПередВыгрузкойТипа(
				Неопределено, 
				Неопределено, 
				ТипОбщихДанных, 
				Ложь);
		Исключение
			ОшибкиВыгружаемыхДанных.Добавить(ТехнологияСервиса.КраткийТекстОшибки(ИнформацияОбОшибке()));
		КонецПопытки;

	КонецЦикла;
	
	Для Каждого ОшибкаМетаданноеНеВключеноВПланОбмена Из ОшибкиМетаданныеНеВключеныВПланОбмена(ТипыМоделиДанных, Ложь) Цикл
		ОшибкиВыгружаемыхДанных.Добавить(ОшибкаМетаданноеНеВключеноВПланОбмена);
	КонецЦикла;
			
	Возврат ОшибкиВыгружаемыхДанных;

КонецФункции

// Проверяет, что переданные метаданные включены в план обмена Миграция приложений
// 
// Параметры:
//  ТипыМоделиДанных - Массив из ОбъектМетаданных - Типы модели данных:
// * Имя - Строка -
// * Измерения - Массив из ОбъектМетаданных -
// УчитыватьДобавленныеВРасширении - Булево - Включает\отключает проверку для объектов метаданных расширений
// 
// Возвращаемое значение:
//  Массив из Строка - Текстовые представления ошибок
Функция ОшибкиМетаданныеНеВключеныВПланОбмена(ТипыМоделиДанных, УчитыватьДобавленныеВРасширении = Истина) Экспорт
	
	Ошибки = Новый Массив;
	ИсключаемыеТипы = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыИсключаемыеИзВыгрузкиЗагрузки();
		
	Для Каждого ТипОбщихДанных Из ТипыМоделиДанных Цикл
	
		Если Метаданные.ПланыОбмена.МиграцияПриложений.Состав.Содержит(ТипОбщихДанных)
			Или Метаданные.РегламентныеЗадания.Содержит(ТипОбщихДанных)
			Или Метаданные.ВнешниеИсточникиДанных.Содержит(ТипОбщихДанных)
			Или Метаданные.ПланыОбмена.Содержит(ТипОбщихДанных) 
			Или (Не УчитыватьДобавленныеВРасширении И ТипОбщихДанных.РасширениеКонфигурации() <> Неопределено)
			Или ИсключаемыеТипы.Найти(ТипОбщихДанных) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
			
		ИмяМодуля = "ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки";
		ШаблонТекстаОшибки = НСтр("ru = 'Объект метаданных %1 не включен в план обмена Миграция приложений. 
			|Его необходимо включить в состав плана обмена Миграция приложений с запрещенной авторегистрацей. 
			|В случае, если объект не должен выгружаться, необходимо дополнительно добавить его в исключаемые из выгрузки. См. %2'");
		Ошибки.Добавить(СтрШаблон(ШаблонТекстаОшибки, ТипОбщихДанных.ПолноеИмя(), ИмяМодуля));
		
	КонецЦикла;
	
	Возврат Ошибки;
	
КонецФункции

Функция НеобходимоПодсчитыватьКоличествоОбъектов(ПараметрыВыгрузкиЗагрузки) Экспорт
	
	Возврат НеобходимоФиксироватьСостояниеВыгрузкиЗагрузкиОбластиДанных(ПараметрыВыгрузкиЗагрузки)
		Или ИспользоватьМногопоточнуюВыгрузкуЗагрузку(ПараметрыВыгрузкиЗагрузки);
	
КонецФункции

Функция ИспользоватьМногопоточнуюВыгрузкуЗагрузку(ПараметрыВыгрузкиЗагрузки) Экспорт
	
	Если Не ЗначениеЗаполнено(ПараметрыВыгрузкиЗагрузки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ПараметрыВыгрузкиЗагрузки.Свойство("КоличествоПотоков")
		И ПараметрыВыгрузкиЗагрузки.КоличествоПотоков > 1 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция НеобходимоФиксироватьСостояниеВыгрузкиЗагрузкиОбластиДанных(ПараметрыВыгрузкиЗагрузки) Экспорт
	
	Если Не ЗначениеЗаполнено(ПараметрыВыгрузкиЗагрузки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ИдентификаторСостояния = Неопределено;
	ПараметрыВыгрузкиЗагрузки.Свойство("ИдентификаторСостояния", ИдентификаторСостояния);
	
	Возврат ЗначениеЗаполнено(ИдентификаторСостояния);
	
КонецФункции

Функция СостояниеВыгрузкиЗагрузкиОбластиДанных(ИдентификаторСостояния) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	СостоянияВыгрузкиЗагрузкиОбластейДанных.ОбластьДанныхВспомогательныеДанные КАК ОбластьДанных,
	|	СостоянияВыгрузкиЗагрузкиОбластейДанных.ЗагрузкаОбластиДанных КАК ЗагрузкаОбластиДанных,
	|	СостоянияВыгрузкиЗагрузкиОбластейДанных.ПроцентЗавершения,
	|	СостоянияВыгрузкиЗагрузкиОбластейДанных.РасчетнаяДатаЗавершения,
	|	СостоянияВыгрузкиЗагрузкиОбластейДанных.ИмяОбрабатываемогоОбъектаМетаданных,
	|	СостоянияВыгрузкиЗагрузкиОбластейДанных.ОбработаноОбъектов,
	|	СостоянияВыгрузкиЗагрузкиОбластейДанных.ОбработаноОбъектовДоТекущегоОбъектаМетаданных,
	|	СостоянияВыгрузкиЗагрузкиОбластейДанных.ДатаНачала,
	|	СостоянияВыгрузкиЗагрузкиОбластейДанных.ДатаНачалаОбработкиОбъектов <> ДАТАВРЕМЯ(1, 1, 1) КАК
	|		ОбработкаОбъектовЗапущена,
	|	СостоянияВыгрузкиЗагрузкиОбластейДанных.ДатаЗавершенияОбработкиОбъектов <> ДАТАВРЕМЯ(1, 1, 1) КАК
	|		ОбработкаОбъектовЗавершена,
	|	СостоянияВыгрузкиЗагрузкиОбластейДанных.ФактическаяДатаЗавершения КАК ФактическаяДатаЗавершения
	|ИЗ
	|	РегистрСведений.СостоянияВыгрузкиЗагрузкиОбластейДанных КАК СостоянияВыгрузкиЗагрузкиОбластейДанных
	|ГДЕ
	|	СостоянияВыгрузкиЗагрузкиОбластейДанных.Идентификатор = &Идентификатор");
	
	Запрос.УстановитьПараметр("Идентификатор", ИдентификаторСостояния);

	ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
	
	Если Не ЗначениеЗаполнено(ТаблицаРезультата) Тогда
		Возврат Неопределено;		
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(ТаблицаРезультата)[0];
	
КонецФункции

Функция ПредставлениеСостоянияВыгрузкиЗагрузкиОбластиДанных(СостояниеВыгрузкиЗагрузкиОбластиДанных, ЧасовойПояс = Неопределено) Экспорт
		
	Если Не СостояниеВыгрузкиЗагрузкиОбластиДанных.ОбработкаОбъектовЗапущена Тогда
		
		Возврат ВыгрузкаЗагрузкаДанныхКлиентСервер.ПредставлениеСостоянияПодготовкиВыгрузкиЗагрузкиОбластиДанных(
			СостояниеВыгрузкиЗагрузкиОбластиДанных.ЗагрузкаОбластиДанных);
				
	ИначеЕсли СостояниеВыгрузкиЗагрузкиОбластиДанных.ОбработкаОбъектовЗавершена Тогда
		
		Если СостояниеВыгрузкиЗагрузкиОбластиДанных.ЗагрузкаОбластиДанных Тогда
			ПредставлениеСостояния = НСтр("ru = 'Выполняется завершение загрузки данных.'");
		Иначе
			ПредставлениеСостояния = НСтр("ru = 'Выполняется завершение выгрузки данных.'");
		КонецЕсли;	
		
	Иначе
		
		ЧастиПредставленияСостояния = Новый Массив();
		
		Если СостояниеВыгрузкиЗагрузкиОбластиДанных.ЗагрузкаОбластиДанных Тогда
			ПерваяЧастьПредставленияСостояния = НСтр("ru = 'Выполняется загрузка данных.'");
		Иначе
			ПерваяЧастьПредставленияСостояния = НСтр("ru = 'Выполняется выгрузка данных.'");
		КонецЕсли;
		
		ЧастиПредставленияСостояния.Добавить(ПерваяЧастьПредставленияСостояния);		
		
		РасчетнаяДатаЗавершения = СостояниеВыгрузкиЗагрузкиОбластиДанных.РасчетнаяДатаЗавершения;
		Если ЗначениеЗаполнено(РасчетнаяДатаЗавершения) Тогда
			
			Если ЧасовойПояс = Неопределено Тогда 
				ЧасовойПояс = ЧасовойПоясСеанса();
			КонецЕсли;
			
			РасчетнаяДатаЗавершенияВМестномВремени = МестноеВремя(РасчетнаяДатаЗавершения, ЧасовойПояс);
			ТекущаяДатаВМестномВремени = МестноеВремя(ТекущаяУниверсальнаяДата(), ЧасовойПояс);
			
			Если НачалоДня(ТекущаяДатаВМестномВремени) = НачалоДня(РасчетнаяДатаЗавершенияВМестномВремени) Тогда
				ШаблонПредставленияДатыЗавершения = НСтр("ru = 'Расчетное время завершения %1.'");
				ФорматнаяСтрока = "ДФ='HH:mm';";
			Иначе
				ШаблонПредставленияДатыЗавершения = НСтр("ru = 'Расчетная дата завершения %1.'");
				ФорматнаяСтрока = "ДФ='dd MMMM HH:mm';";
			КонецЕсли;

			ВтораяЧастьПредставленияСостояния = СтрШаблон(
				ШаблонПредставленияДатыЗавершения,
				Формат(РасчетнаяДатаЗавершенияВМестномВремени, ФорматнаяСтрока));
			
			ЧастиПредставленияСостояния.Добавить(ВтораяЧастьПредставленияСостояния);			
		
		КонецЕсли;

		ПредставлениеСостояния = СтрСоединить(ЧастиПредставленияСостояния, " ");
		
	КонецЕсли;
		
	Возврат ПредставлениеСостояния;
	
КонецФункции

Функция ПроцентЗавершенияВыгрузкиЗагрузкиОбластиДанных(СостояниеВыгрузкиЗагрузкиОбластиДанных) Экспорт
		
	Если СостояниеВыгрузкиЗагрузкиОбластиДанных = Неопределено 
		Или Не СостояниеВыгрузкиЗагрузкиОбластиДанных.ОбработкаОбъектовЗапущена
		Или СостояниеВыгрузкиЗагрузкиОбластиДанных.ОбработкаОбъектовЗавершена Тогда	
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат СостояниеВыгрузкиЗагрузкиОбластиДанных.ПроцентЗавершения;
			
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет наличие права "АдминистрированиеДанных"
//
// Возвращаемое значение:
//	Булево - Истина, если имеется, Ложь - иначе.
//
Функция ПроверитьНаличиеПрав()
	
	Возврат ПравоДоступа("АдминистрированиеДанных", Метаданные);
	
КонецФункции

#КонецОбласти