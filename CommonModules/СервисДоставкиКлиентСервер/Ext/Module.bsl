﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Сервис доставки".
// ОбщийМодуль.СервисДоставкиКлиентСервер.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет многоуровневую структуру данными из одноуровневой структуры.
//
// Параметры:
//  Параметры         - Структура - многоуровневая структура, получатель данных.
//  Данные            - Структура, СтрокаТаблицыЗначений - одноуровневая структура данных, источник данных.
//  ОписаниеДанных    - Массив из Строка - имена колонок строки таблицы значений, для структуры данный параметр игнорируется.
//  Префикс           - Строка - префикс данных источника.
//
Процедура ЗаполнитьСтруктуруПоЛинейнымДанным(Параметры, Данные, ОписаниеДанных = Неопределено, Префикс = "") Экспорт
	
	Для Каждого Параметр Из Параметры Цикл
		
		ИмяКолонки = Префикс + Параметр.Ключ;
		
		Если ТипЗнч(Параметр.Значение) = Тип("Структура") Тогда
			ЗаполнитьСтруктуруПоЛинейнымДанным(Параметр.Значение, Данные, ОписаниеДанных, ИмяКолонки);
		Иначе
			
			Если ТипЗнч(Данные) = Тип("Структура") Тогда
				
				Если Данные.Свойство(ИмяКолонки) Тогда
					Параметры[Параметр.Ключ] = Данные[ИмяКолонки];
				КонецЕсли;
				
			ИначеЕсли ОписаниеДанных.Найти(ИмяКолонки) <> Неопределено Тогда 
				
				Параметры[Параметр.Ключ] = Данные[ИмяКолонки];
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Заполняет многоуровневую структуру данными из одноуровневой структуры.
//
// Параметры:
//  Параметры            - Структура - многоуровневая структура, источник данных.
//  Данные         - Структура - одноуровневая структура данных, получатель данных.
//  Префикс           - Строка - префикс данных получателя.
//
Процедура ЗаполнитьЛинейныеДанныеПоСтруктуре(Параметры, Данные, Префикс = "") Экспорт
	
	Для Каждого Параметр Из Параметры Цикл
		
		ИмяКолонки = Префикс + Параметр.Ключ;
		
		Если ТипЗнч(Параметр.Значение) = Тип("Структура") Тогда
			ЗаполнитьЛинейныеДанныеПоСтруктуре(Параметр.Значение, Данные, ИмяКолонки);
		Иначе
			Данные.Вставить(ИмяКолонки, Параметры[Параметр.Ключ]);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает идентификатор типа грузоперевозки.
// Возвращаемое значение:
//	Число - значение типа грузоперевозки
//
Функция ТипГрузоперевозкиСервис1СДоставка() Экспорт
	
	Возврат 1;
	
КонецФункции
 
// Возвращает идентификатор типа грузоперевозки.
// Возвращаемое значение:
//	Число - значение типа грузоперевозки
//
Функция ТипГрузоперевозкиСервис1СКурьер() Экспорт
	
	Возврат 2;
	
КонецФункции

// Возвращает идентификатор типа грузоперевозки.
// Возвращаемое значение:
//	Число - значение типа грузоперевозки
//
Функция ТипГрузоперевозкиСервис1СКурьерика() Экспорт
	
	Возврат 3;
	
КонецФункции

// Возвращает массив типов документов, используемых в качестве оснований для заказов на доставку
// сервиса Курьерика.
//
// Возвращаемое значение:
//	Массив Из Тип - массив типов документов.
//
Функция ТипыДокументовОснованийКурьерика() Экспорт
	
	МассивТипов = Новый Массив;
	
	СервисДоставкиКлиентСерверПереопределяемый.ПриОпределенииТиповДокументовОснованийКурьерика(МассивТипов);
	
	Возврат МассивТипов;
	
КонецФункции
	
// Возвращает представление сервиса по идентификатору типа грузоперевозки.
// Параметры:
//	ИдентификаторТипаГрузоперевозки - Число - идентификатор типа грузоперевозки.
//
// Возвращаемое значение:
//	Строка - представление типа грузоперевозки.
//
Функция ПредставлениеТипаГрузоперевозки(ИдентификаторТипаГрузоперевозки) Экспорт
	
	Если ИдентификаторТипаГрузоперевозки = 1 Тогда
		Результат = НСтр("ru = '1C:Доставка'");
	ИначеЕсли ИдентификаторТипаГрузоперевозки = 2 Тогда
		Результат = НСтр("ru = '1C:Курьер'");
	ИначеЕсли ИдентификаторТипаГрузоперевозки = 3 Тогда
		Результат = НСтр("ru = '1C-Курьерика'");
	Иначе
		Результат = "";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает ссылку на web-страницу заказа 1С-Курьерика по переданному трек-номеру.
// Параметры:
//	ТрекНомер - Строка - трек-номер заказа.
//
// Возвращаемое значение:
//	Строка - адрес web-страницы заказа.
//
Функция АдресСтраницыЗаказаНаДоставку1СКурьерика(ТрекНомер) Экспорт
	
	Возврат СтрШаблон("https://app.courierica.ru/#/order/%1", ТрекНомер);
	
КонецФункции

// Возвращает ссылку на web-страницу настройки опции 1С-Курьерика.
// Возвращаемое значение:
//	Строка - адрес web-страницы настройки опции.
//
Функция АдресСтраницыОпцияКурьерика() Экспорт
	
	Возврат "https://portal.1c.ru/application/list";
	
КонецФункции

// Варианты времени отгрузки.
// 
// Возвращаемое значение:
//  Структура - Варианты времени отгрузки:
// * КакМожноСкорее - Число - устанавливается в 0
// * ВОпределенноеВремя - Число - устанавливается в 1
// * ВТечениеДня - Число - устанавливается в 2
Функция ВариантыВремениОтгрузки() Экспорт
	
	ВариантыВремениОтгрузки = Новый Структура();
	ВариантыВремениОтгрузки.Вставить("КакМожноСкорее", 0);
	ВариантыВремениОтгрузки.Вставить("ВОпределенноеВремя", 1);
	ВариантыВремениОтгрузки.Вставить("ВТечениеДня", 2);
	
	Возврат ВариантыВремениОтгрузки;
	
КонецФункции

// Варианты времени отгрузки списком.
// 
// Возвращаемое значение:
//  СписокЗначений из Строка - Список вариантов времени отгрузки
Функция СписокВариантовВремениОтгрузки() Экспорт
	
	ВариантыВремениОтгрузки = ВариантыВремениОтгрузки();

	Список = Новый СписокЗначений();

	Список.Добавить(ВариантыВремениОтгрузки.КакМожноСкорее, НСтр("ru='как можно скорее'"));
	Список.Добавить(ВариантыВремениОтгрузки.ВОпределенноеВремя, НСтр("ru='в определенное время'"));
	Список.Добавить(ВариантыВремениОтгрузки.ВТечениеДня, НСтр("ru='в течение дня (дешевле)'"));
	
	Возврат Список;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область Словарь

Функция ИмяПроцедурыПолучитьЗаказНаДоставку() Экспорт
	
	Возврат "ПолучитьЗаказНаДоставку";
	
КонецФункции

Функция ИмяПроцедурыОбновитьЗаказНаДоставку() Экспорт
	
	Возврат "ОбновитьЗаказНаДоставку";
	
КонецФункции

Функция ИмяПроцедурыПолучитьМультизаказНаДоставку() Экспорт
	
	Возврат "ПолучитьМультизаказНаДоставку";
	
КонецФункции

Функция ИмяПроцедурыОбновитьМультизаказНаДоставку() Экспорт
	
	Возврат "ОбновитьМультизаказНаДоставку";
	
КонецФункции

Функция ИмяПроцедурыОтменитьМультизаказНаДоставку() Экспорт
	
	Возврат "ОтменитьМультизаказНаДоставку";
	
КонецФункции

Функция ИмяПроцедурыПолучитьУслугиТарифов() Экспорт
	
	Возврат "ПолучитьУслугиТарифов";
	
КонецФункции

Функция ИмяПроцедурыПолучитьТарифы() Экспорт
	
	Возврат "ПолучитьТарифы";
	
КонецФункции

Функция ИмяПроцедурыПолучитьТариф() Экспорт
	
	Возврат "ПолучитьТариф";
	
КонецФункции

Функция ИмяПроцедурыСоздатьИзменитьЗаказНаДоставку() Экспорт
	
	Возврат "СоздатьИзменитьЗаказНаДоставку";
	
КонецФункции

Функция ИмяПроцедурыОформитьЗаказНаДоставку() Экспорт
	
	Возврат "ОформитьЗаказНаДоставку";
	
КонецФункции

Функция ИмяПроцедурыСоздатьМультизаказНаДоставку() Экспорт
	
	Возврат "СоздатьМультизаказНаДоставку";
	
КонецФункции

Функция ИмяПроцедурыОформитьМультизаказНаДоставку() Экспорт
	
	Возврат "ОформитьМультизаказНаДоставку";
	
КонецФункции

Функция ИмяПроцедурыДобавитьЗаказНаДоставкуВМультизаказ() Экспорт
	
	Возврат "ДобавитьЗаказНаДоставкуВМультизаказ";
	
КонецФункции

Функция ИмяПроцедурыОтменитьЗаказНаДоставку() Экспорт
	
	Возврат "ОтменитьЗаказНаДоставку";
	
КонецФункции

Функция ИмяПроцедурыПолучитьДоступныеПечатныеФормы() Экспорт
	
	Возврат "ПолучитьДоступныеПечатныеФормы";
	
КонецФункции

Функция ИмяПроцедурыПолучитьФайлыПечатныхФорм() Экспорт
	
	Возврат "ПолучитьФайлыПечатныхФорм";
	
КонецФункции

Функция ИмяПроцедурыПолучитьЗаказыНаДоставку() Экспорт
	
	Возврат "ПолучитьЗаказыНаДоставку";
	
КонецФункции

Функция ИмяПроцедурыПолучитьСостояния() Экспорт
	
	Возврат "ПолучитьСостояния";
	
КонецФункции

Функция ИмяПроцедурыПолучитьТипыГрузоперевозки() Экспорт
	
	Возврат "ПолучитьТипыГрузоперевозки";
	
КонецФункции

Функция ИмяПроцедурыПолучитьГрузоперевозчиков() Экспорт
	
	Возврат "ПолучитьГрузоперевозчиков";
	
КонецФункции

Функция ИмяПроцедурыПолучитьПунктыВыдачиКлиента() Экспорт
	
	Возврат "ПолучитьПунктыВыдачиКлиента";
	
КонецФункции

Функция ИмяПроцедурыПолучитьСостояниеПодключенияОрганизации() Экспорт
	
	Возврат "ПолучитьСостояниеПодключенияОрганизации";
	
КонецФункции

Функция ИмяПроцедурыОтправитьЗапросНаПолучениеРегистрационныхДанных() Экспорт
	
	Возврат "ОтправитьЗапросНаПолучениеРегистрационныхДанных";
	
КонецФункции

Функция ИмяПроцедурыПолучитьДоступныеТерминалы() Экспорт
	
	Возврат "ПолучитьДоступныеТерминалы";
	
КонецФункции

Функция ИмяПроцедурыПолучитьДанныеГрузоперевозчика() Экспорт
	
	Возврат "ПолучитьДанныеГрузоперевозчика";
	
КонецФункции

Функция ИмяПроцедурыПолучитьДанныеУслуги() Экспорт
	
	Возврат "ПолучитьДанныеУслуги";
	
КонецФункции

Функция ИмяПроцедурыПолучитьДанныеТерминала() Экспорт
	
	Возврат "ПолучитьДанныеТерминала";
	
КонецФункции

Функция ИмяПроцедурыПолучитьГрафикДвиженияЗаказа() Экспорт
	
	Возврат "ПолучитьГрафикДвиженияЗаказа";
	
КонецФункции

Функция ИмяПроцедурыПолучитьГрафикДвиженияЗаказаПоТрекНомеру() Экспорт
	
	Возврат "ПолучитьГрафикДвиженияЗаказаПоТрекНомеру";
	
КонецФункции

Функция ИмяПроцедурыПолучитьНастройкиАвторизации() Экспорт
	
	Возврат "ПолучитьНастройкиАвторизации";
	
КонецФункции

Функция ИмяПроцедурыЗаписатьНастройкиАвторизации() Экспорт
	
	Возврат "ЗаписатьНастройкиАвторизации";
	
КонецФункции

Функция ИмяПроцедурыПолучитьДанныеПоТарифу() Экспорт
	
	Возврат "ПолучитьДанныеПоТарифу";
	
КонецФункции

Функция ИмяПроцедурыДобавитьДокументОснованиеВВыбранныйЗаказНаДоставку() Экспорт
	
	Возврат "ДобавитьДокументОснованиеВВыбранныйЗаказНаДоставку";
	
КонецФункции

Функция ИмяПроцедурыУстановитьТарифПоУмолчанию() Экспорт
	
	Возврат "УстановитьТарифПоУмолчанию";
	
КонецФункции

Функция ИмяПроцедурыСброситьТарифПоУмолчанию() Экспорт
	
	Возврат "СброситьТарифПоУмолчанию";
	
КонецФункции

Функция ИмяПроцедурыСохранитьПараметрыТарифа() Экспорт
	
	Возврат "СохранитьПараметрыТарифа";
	
КонецФункции

Функция ИмяПроцедурыПолучитьДоступныеДляИзмененияРеквизиты() Экспорт
	
	Возврат "ПолучитьДоступныеДляИзмененияРеквизиты";
	
КонецФункции

Функция ИмяПроцедурыПолучитьСостояниеОпцииКурьерика() Экспорт
	
	Возврат "ПолучитьСостояниеОпцииКурьерика";
	
КонецФункции

// Возвращает имя регламентного задания "Получение наложенных платежей".
// 
// Возвращаемое значение:
//  Строка - имя регламентного задания "Получение наложенных платежей".
//
Функция ИмяРегламентногоЗаданияПолучениеНаложенныхПлатежей() Экспорт
	
	Возврат "ЗагрузкаДанныхПоНаложеннымПлатежамСервисДоставки";
	
КонецФункции

// Имя процедуры выполнить загрузку данных по наложенным платежам.
// 
// Возвращаемое значение:
//  Строка - Имя процедуры выполнить загрузку данных по наложенным платежам
//
Функция ИмяПроцедурыВыполнитьЗагрузкуДанныхПоНаложеннымПлатежам() Экспорт
	
	Возврат "ВыполнитьЗагрузкуДанныхПоНаложеннымПлатежам";
	
КонецФункции

// Возвращает идентификатор режима мастера
// 
// Возвращаемое значение:
//  Число - идентификатор режима мастера
//
Функция РежимМастераНовый() Экспорт
	
	Возврат 0;
	
КонецФункции

// Возвращает идентификатор режима мастера
// 
// Возвращаемое значение:
//  Число - идентификатор режима мастера
//
Функция РежимМастераЧерновик() Экспорт
	
	Возврат 1;
	
КонецФункции

// Возвращает идентификатор режима мастера
// 
// Возвращаемое значение:
//  Число - идентификатор режима мастера
//
Функция РежимМастераЗарегистрирован() Экспорт
	
	Возврат 2;
	
КонецФункции

// Способ отгрузки груза отправителем перевозчику. От адреса.
// 
// Возвращаемое значение:
//  Число - идентификатор способа отгрузки
//
Функция СпособОтгрузкиОтАдреса() Экспорт
	
	Возврат 2;
	
КонецФункции

// Способ отгрузки груза отправителем перевозчику. От терминала.
// 
// Возвращаемое значение:
//  Число - идентификатор способа отгрузки
//
Функция СпособОтгрузкиОтТерминала() Экспорт
	
	Возврат 1;
	
КонецФункции

// Способ доставки груза перевозчиком до получателя. До адреса.
// 
// Возвращаемое значение:
//  Число - идентификатор способа доставки
//
Функция СпособДоставкиДоАдреса() Экспорт
	
	Возврат 2;
	
КонецФункции

// Способ доставки груза перевозчиком до получателя. До терминала.
// 
// Возвращаемое значение:
//  Число - идентификатор способа доставки
//
Функция СпособДоставкиДоТерминала() Экспорт
	
	Возврат 1;
	
КонецФункции

#Область КонструкторыДанных

// Возвращает параметры объекта данных сервиса доставки.
//
// Возвращаемое значение:
//  Структура - параметры, необходимые для формирования запроса.
//
Функция НовыйПараметрыЗаказаНаДоставкуДляСписка() Экспорт
	
	ПараметрыЗаказа = Новый Структура();
	
	ПараметрыЗаказа.Вставить("Идентификатор", "");
	ПараметрыЗаказа.Вставить("ТрекНомер", "");
	ПараметрыЗаказа.Вставить("НомерЗаказа", "");
	ПараметрыЗаказа.Вставить("ДатаЗаказа", Дата(1, 1, 1));
	ПараметрыЗаказа.Вставить("ДатаСозданияЗаказа", Дата(1, 1, 1));
	ПараметрыЗаказа.Вставить("ДатаОтгрузки", Дата(1, 1, 1));
	ПараметрыЗаказа.Вставить("ВариантВремениОтгрузки", 0); 
	ПараметрыЗаказа.Вставить("ДатаДоставки", Дата(1, 1, 1));
	ПараметрыЗаказа.Вставить("ОбязательныеРеквизитыЗаполнены", Ложь);
	ПараметрыЗаказа.Вставить("Проверен", Ложь);
	ПараметрыЗаказа.Вставить("МультизаказДата", Дата(1, 1, 1));
	ПараметрыЗаказа.Вставить("МультизаказНомер", "");
	ПараметрыЗаказа.Вставить("МультизаказИдентификатор", "");
	ПараметрыЗаказа.Вставить("МультизаказТипНаименование", "");
	ПараметрыЗаказа.Вставить("МультизаказТипИдентификатор", "");
	ПараметрыЗаказа.Вставить("МультизаказПредставление", "");
	ПараметрыЗаказа.Вставить("ЭтоМультизаказ", Ложь);
	ПараметрыЗаказа.Вставить("ПорядковыйНомер", 0);
	ПараметрыЗаказа.Вставить("НомерЗаказаДляПечати", "");
	ПараметрыЗаказа.Вставить("ДокументыОснования", Неопределено);
	ПараметрыЗаказа.Вставить("ДокументОснованиеПредставление", "");
	ПараметрыЗаказа.Вставить("Сумма", 0);
	ПараметрыЗаказа.Вставить("Отправитель", Неопределено);
	ПараметрыЗаказа.Вставить("ОтправительИНН", "");
	ПараметрыЗаказа.Вставить("ОтправительКПП", "");
	ПараметрыЗаказа.Вставить("ОтправительНаименование", "");
	ПараметрыЗаказа.Вставить("АдресОтгрузкиПредставление", "");
	ПараметрыЗаказа.Вставить("АдресОтгрузкиНаименование", "");
	ПараметрыЗаказа.Вставить("АдресОтгрузкиТипНаименование", "");
	ПараметрыЗаказа.Вставить("Получатель", Неопределено);
	ПараметрыЗаказа.Вставить("ПолучательИНН", "");
	ПараметрыЗаказа.Вставить("ПолучательКПП", "");
	ПараметрыЗаказа.Вставить("ПолучательНаименование", "");
	ПараметрыЗаказа.Вставить("АдресДоставкиПредставление", "");
	ПараметрыЗаказа.Вставить("АдресДоставкиНаименование", "");
	ПараметрыЗаказа.Вставить("АдресДоставкиТипНаименование", "");
	ПараметрыЗаказа.Вставить("ПунктВыдачиКлиентаКод", "");
	ПараметрыЗаказа.Вставить("ПунктВыдачиКлиентаНаименование", "");
	ПараметрыЗаказа.Вставить("ЗаборОтАдреса");
	ПараметрыЗаказа.Вставить("ДоставкаДоАдреса");
	ПараметрыЗаказа.Вставить("ПеревозчикНаименование", "");
	ПараметрыЗаказа.Вставить("ПеревозчикИдентификатор", "");
	ПараметрыЗаказа.Вставить("ТарифНаименование", "");
	ПараметрыЗаказа.Вставить("ТарифИдентификатор", "");
	ПараметрыЗаказа.Вставить("Плательщик", Неопределено);
	ПараметрыЗаказа.Вставить("ПлательщикИНН", "");
	ПараметрыЗаказа.Вставить("ПлательщикКПП", "");
	ПараметрыЗаказа.Вставить("ПлательщикНаименование", "");
	ПараметрыЗаказа.Вставить("Оплачен", Ложь);
	ПараметрыЗаказа.Вставить("НаложенныйПлатежПолучен", Ложь);
	ПараметрыЗаказа.Вставить("СуммаНаложенногоПлатежа", 0);
	ПараметрыЗаказа.Вставить("СуммаНаложенногоПлатежаДополнительный", 0);
	ПараметрыЗаказа.Вставить("НаложенныйПлатежВидОплаты", 0);
	ПараметрыЗаказа.Вставить("СуммаНаложенногоПлатежаДополнительный", 0);
	ПараметрыЗаказа.Вставить("Состояние", "");
	ПараметрыЗаказа.Вставить("СостояниеИдентификатор", 0);
	ПараметрыЗаказа.Вставить("ВалютаКод", "643");
	ПараметрыЗаказа.Вставить("ВалютаНаименование", "RUB");
	ПараметрыЗаказа.Вставить("ДоступнаОтмена", Ложь);
	ПараметрыЗаказа.Вставить("КоличествоГрузовыхМест", 0);
	ПараметрыЗаказа.Вставить("ГрузВес", 0);
	ПараметрыЗаказа.Вставить("ГрузОбъем", 0);
	ПараметрыЗаказа.Вставить("ГрузСтоимость", 0);
	
	ПараметрыЗаказа.Вставить("ОтправительКонтактноеЛицоИдентификатор", Неопределено);
	ПараметрыЗаказа.Вставить("ОтправительКонтактноеЛицоНаименование", "");
	ПараметрыЗаказа.Вставить("ОтправительКонтактноеЛицоEmail", "");
	ПараметрыЗаказа.Вставить("ОтправительКонтактноеЛицоТелефонПредставление", "");
	ПараметрыЗаказа.Вставить("ОтправительКонтактноеЛицоТелефонЗначение", "");
	ПараметрыЗаказа.Вставить("ОтправительКонтактноеЛицоТелефонДополнительныйПредставление", "");
	ПараметрыЗаказа.Вставить("ОтправительКонтактноеЛицоТелефонДополнительныйЗначение", "");
	
	ПараметрыЗаказа.Вставить("ПолучательКонтактноеЛицоИдентификатор", Неопределено);
	ПараметрыЗаказа.Вставить("ПолучательКонтактноеЛицоНаименование", "");
	ПараметрыЗаказа.Вставить("ПолучательКонтактноеЛицоEmail", "");
	ПараметрыЗаказа.Вставить("ПолучательКонтактноеЛицоТелефонПредставление", "");
	ПараметрыЗаказа.Вставить("ПолучательКонтактноеЛицоТелефонЗначение", "");
	ПараметрыЗаказа.Вставить("ПолучательКонтактноеЛицоТелефонДополнительныйПредставление", "");
	ПараметрыЗаказа.Вставить("ПолучательКонтактноеЛицоТелефонДополнительныйЗначение", "");

	Возврат ПараметрыЗаказа;
		
КонецФункции

#КонецОбласти

#Область ПредставлениеОбъектов

Функция ПредставлениеЗаказаНаДоставку(Параметры, ПолноеНаименование = Ложь) Экспорт
	
	ПредставлениеДляСписка = НСтр("ru='Заказ'");
	
	Если Параметры.НомерЗаказа <> "" Тогда
		ПредставлениеДляСписка = ПредставлениеДляСписка
			+ " "
			+ СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Параметры.НомерЗаказа,"0","СЛЕВА");
	КонецЕсли;
		
	Если ПолноеНаименование Тогда
		
		ПредставлениеДляСписка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 от %2'"),
			ПредставлениеДляСписка,
			Формат(Параметры.ДатаЗаказа, "ДЛФ=D"));
		
	КонецЕсли;
	
	Возврат ПредставлениеДляСписка;
	
КонецФункции

#КонецОбласти

// Параметры:
//	ПредставлениеЗначения - Строка
// Возвращаемое значение:
//	Число
Функция СпособОпределенияКонтактногоЛицаНеЗадан(ПредставлениеЗначения = "") Экспорт
	
	ПредставлениеЗначения = "";
	Возврат 0;
	
КонецФункции

// Параметры:
//	ПредставлениеЗначения - Строка
// Возвращаемое значение:
//	Число
Функция СпособОпределенияКонтактногоЛицаВручную(ПредставлениеЗначения = "") Экспорт
	
	ПредставлениеЗначения = НСтр("ru='Указывать вручную'");
	Возврат 1;
	
КонецФункции

// Параметры:
//	ПредставлениеЗначения - Строка
// Возвращаемое значение:
//	Число
Функция СпособОпределенияКонтактногоЛицаОтветственныйЗаДоставку(ПредставлениеЗначения = "") Экспорт
	
	ПредставлениеЗначения = НСтр("ru='Ответственный за доставку'");
	Возврат 2;
	
КонецФункции

#КонецОбласти

#КонецОбласти
