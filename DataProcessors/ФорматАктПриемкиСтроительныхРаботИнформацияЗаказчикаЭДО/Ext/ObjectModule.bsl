﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем Менеджер; // ОбработкаМенеджер.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО
Перем ПространствоИмен; // Строка
Перем ДатаФормирования; // Дата
Перем ПараметрыОсновногоТитула; // см. ПолучитьПараметрыОсновногоТитула
Перем ОшибкиЗаполнения; // Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область СтруктураДанных

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИнформацияЗаказчика:
//  * ДоверенностьНаСоставление - Неопределено - значение по умолчанию
//  * ДоверенностьНаСоставление - см. НовоеОписаниеДокумента
//  * ДокументОтказа - Неопределено - значение по умолчанию
//  * ДокументОтказа - см. НовоеОписаниеДокумента
//  * ДокументПодтвержденияНедостатков - Неопределено - значение по умолчанию
//  * ДокументПодтвержденияНедостатков - см. НовоеОписаниеДокумента
//  * ИтогиПринятияНаУсловияхУменьшенияСтоимости - Неопределено - значение по умолчанию
//  * ИтогиПринятияНаУсловияхУменьшенияСтоимости - см. НовыеИтогиПринятияНаУсловияхУменьшенияСтоимости
//  * РешениеПоПредоставленнымРасчетам - Неопределено - значение по умолчанию
//  * РешениеПоПредоставленнымРасчетам - см. НовоеРешениеПоПредоставленнымРасчетам
//
Функция ИнформацияЗаказчика() Экспорт
	Если Не ЗначениеЗаполнено(ИнформацияЗаказчика) Тогда
		ИнформацияЗаказчика.Добавить();
		ИнформацияЗаказчика[0].КодОперации = КодыОперации().ПринятоБезЗамечаний;
		ИнформацияЗаказчика[0].ДатаРешения = ТекущаяДатаСеанса();
	КонецЕсли;
	Возврат ИнформацияЗаказчика[0];
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИтогиПринятияРаботНаУсловияхУменьшенияСтоимости
//
Функция НовыеИтогиПринятияНаУсловияхУменьшенияСтоимости() Экспорт
	Возврат ИтогиПринятияРаботНаУсловияхУменьшенияСтоимости.Добавить();
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.РешениеПоПредоставленнымРасчетам:
//  * НеучтенныеДокументы - Массив Из см. НовоеОписаниеДокумента
//  * ЛишниеДокументы - Массив Из см. НовоеОписаниеДокумента
//
Функция НовоеРешениеПоПредоставленнымРасчетам() Экспорт
	Запись = РешениеПоПредоставленнымРасчетам.Добавить();
	Запись.НеучтенныеДокументы = Новый Массив;
	Запись.ЛишниеДокументы = Новый Массив;
	Возврат Запись;
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИдентифицирующиеПризнакиДокументов:
//  * Стороны - Массив Из см. НовыеПризнакиФизЛица
//  * Стороны - Массив Из см. НовыеПризнакиЮрЛица
//  * Стороны - Массив Из см. НовыеПризнакиИностраннойОрганизации
//  * Стороны - Массив Из см. НовыеПризнакиИностранногоГражданина
//  * Стороны - Массив Из см. НовыеПризнакиОрганаИсполнительнойВласти
//
Функция НовоеОписаниеДокумента() Экспорт
	Запись = ИдентифицирующиеПризнакиДокументов.Добавить();
	Запись.Стороны = Новый Массив;
	Возврат Запись;
КонецФункции

// Параметры:
//  ИНН - см. Обработка.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИдентифицирующиеПризнакиЮрЛиц.ИНН
// 
// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИдентифицирующиеПризнакиЮрЛиц
//
Функция НовыеПризнакиЮрЛица(ИНН = Неопределено) Экспорт
	Запись = ИдентифицирующиеПризнакиЮрЛиц.Добавить();
	Запись.ИНН = ИНН; 
	Возврат Запись;
КонецФункции

// Параметры:
//  ИНН - см. Обработка.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИдентифицирующиеПризнакиФизЛиц.ИНН
// 
// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИдентифицирующиеПризнакиФизЛиц
//
Функция НовыеПризнакиФизЛица(ИНН = Неопределено) Экспорт
	Запись = ИдентифицирующиеПризнакиФизЛиц.Добавить();
	Запись.ИНН = ИНН;
	Возврат Запись;
КонецФункции

// Параметры:
//  Страна - см. Обработка.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИдентифицирующиеПризнакиИностранныхОрганизаций.Страна
//  Наименование - см. Обработка.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИдентифицирующиеПризнакиИностранныхОрганизаций.Наименование
//  Идентификатор - см. Обработка.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИдентифицирующиеПризнакиИностранныхОрганизаций.Идентификатор
// 
// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИдентифицирующиеПризнакиИностранныхОрганизаций
//
Функция НовыеПризнакиИностраннойОрганизации(Страна = Неопределено, Наименование = Неопределено,
	Идентификатор = Неопределено) Экспорт
	Запись = ИдентифицирующиеПризнакиИностранныхОрганизаций.Добавить();
	Запись.Страна = Страна;
	Запись.Наименование = Наименование;
	Запись.Идентификатор = Идентификатор;
	Возврат Запись;
КонецФункции

// Параметры:
//  Страна - см. Обработка.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИдентифицирующиеПризнакиИностранныхГраждан.Страна
//  ФИО - см. Обработка.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИдентифицирующиеПризнакиИностранныхГраждан.ФИО
//  Идентификатор - см. Обработка.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИдентифицирующиеПризнакиИностранныхГраждан.Идентификатор
// 
// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИдентифицирующиеПризнакиИностранныхГраждан
//
Функция НовыеПризнакиИностранногоГражданина(Страна = Неопределено, ФИО = Неопределено,
	Идентификатор = Неопределено) Экспорт
	Запись = ИдентифицирующиеПризнакиИностранныхГраждан.Добавить();
	Запись.Страна = Страна;
	Запись.ФИО = ФИО;
	Запись.Идентификатор = Идентификатор;
	Возврат Запись;
КонецФункции

// Параметры:
//  Наименование - см. Обработка.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИдентифицирующиеПризнакиОргановИсполнительнойВласти.Наименование
// 
// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИдентифицирующиеПризнакиОргановИсполнительнойВласти
//
Функция НовыеПризнакиОрганаИсполнительнойВласти(Наименование = Неопределено) Экспорт
	Запись = ИдентифицирующиеПризнакиОргановИсполнительнойВласти.Добавить();
	Запись.Наименование = Наименование;
	Возврат Запись;
КонецФункции

// Параметры:
//  Фамилия - см. Обработка.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ФИО.Фамилия
//  Имя - см. Обработка.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ФИО.Имя
//  Отчество - см. Обработка.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ФИО.Отчество
// 
// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ФИО
//
Функция НовыеФИО(Фамилия = Неопределено, Имя = Неопределено, Отчество = Неопределено) Экспорт
	Запись = ФИО.Добавить();
	Запись.Фамилия = Фамилия;
	Запись.Имя = Имя;
	Запись.Отчество = Отчество;
	Возврат Запись;
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.Подписанты:
//  * ФИО - см. НовыеФИО
//  * ЭлектроннаяДоверенность - см. НоваяЭлектроннаяДоверенность
//  * БумажнаяДоверенность - см. НоваяБумажнаяДоверенность
//
Функция НовыйПодписант() Экспорт
	Возврат Подписанты.Добавить();
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ЭлектронныеДоверенности
//
Функция НоваяЭлектроннаяДоверенность() Экспорт
	Возврат ЭлектронныеДоверенности.Добавить();
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.БумажныеДоверенности:
//  * ПодписалФИО - см. НовыеФИО
//
Функция НоваяБумажнаяДоверенность() Экспорт
	Возврат БумажныеДоверенности.Добавить();
КонецФункции

#КонецОбласти

#Область Перечисления

// Возвращаемое значение:
//  ФиксированнаяСтруктура:
// * Отказ - Строка
// * ПринятоБезЗамечаний - Строка
// * ПринятоСБезвозмезднымУстранениемНедостатков - Строка
// * ПринятоСУменьшениемСтоимостиДоговора - Строка
// * ПринятоСВозмещениемРасходов - Строка
//
Функция КодыОперации() Экспорт
	Типы = Новый Структура;
	Типы.Вставить("Отказ", "0");
	Типы.Вставить("ПринятоБезЗамечаний", "1");
	Типы.Вставить("ПринятоСБезвозмезднымУстранениемНедостатков", "2");
	Типы.Вставить("ПринятоСУменьшениемСтоимостиДоговора", "4");
	Типы.Вставить("ПринятоСВозмещениемРасходов", "5");
	Возврат Новый ФиксированнаяСтруктура(Типы);
КонецФункции

// Возвращаемое значение:
//  ФиксированнаяСтруктура:
// * Согласен - Строка
// * СогласенСДопУдержанием - Строка
// * НеСогласен - Строка
// * РасчетыНеСверялись - Строка
// * СверкаНеПредусмотрена - Строка
//
Функция КодыРешенияПоПредоставленнымРасчетам() Экспорт
	Типы = Новый Структура;
	Типы.Вставить("Согласен", "С представленными подрядчиком сведениями о расчетах согласен");
	Типы.Вставить("СогласенСДопУдержанием", "С представленными подрядчиком сведениями о расчетах согласен, "
		+ "есть информация о дополнительных удержаниях заказчиком в соответствии с "
		+ "законодательством о контрактной системе в сфере закупок товаров, работ, "
		+ "услуг для обеспечения государственных и муниципальных нужд");
	Типы.Вставить("НеСогласен", "С представленными подрядчиком сведениями о расчетах не согласен");
	Типы.Вставить("РасчетыНеСверялись",
		"Представленные подрядчиком сведения о расчетах по договору на момент приемки работ не сверялись");
	Типы.Вставить("СверкаНеПредусмотрена", "Условиями договора строительного подряда сверка расчетов по договору "
		+ "непосредственно в акте о приемке выполненных работ не предусмотрена");
	Возврат Новый ФиксированнаяСтруктура(Типы);
КонецФункции

// Статусы подписанта.
// 
// Возвращаемое значение:
//  ФиксированнаяСтруктура:
// * ПолномочияБезДоверенности - Строка
// * ПолномочияНаОснованииЭлектроннойДоверенности - Строка
// * ПолномочияНаОснованииБумажнойДоверенности - Строка
//
Функция СтатусыПодписанта() Экспорт
	Типы = Новый Структура;
	Типы.Вставить("ПолномочияБезДоверенности", "1");
	Типы.Вставить("ПолномочияНаОснованииЭлектроннойДоверенности", "2");
	Типы.Вставить("ПолномочияНаОснованииБумажнойДоверенности", "3");
	Возврат Новый ФиксированнаяСтруктура(Типы);
КонецФункции

// Типы подписи.
// 
// Возвращаемое значение:
//  ФиксированнаяСтруктура:
// * УсиленнаяКвалифицированная - Строка
// * Простая - Строка
// * УсиленнаяНеквалифицированная - Строка
//
Функция ТипыПодписи() Экспорт
	Типы = Новый Структура;
	Типы.Вставить("УсиленнаяКвалифицированная", "1");
	Типы.Вставить("Простая", "2");
	Типы.Вставить("УсиленнаяНеквалифицированная", "3");
	Возврат Новый ФиксированнаяСтруктура(Типы);
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ТекущаяИнформацияЗаказчика = ИнформацияЗаказчика();
	ОшибкиЗаполнения = ОбработчикОшибок.ПроверитьЗаполнениеДанных(ТекущаяИнформацияЗаказчика, ПроверяемыеРеквизиты);
	Если ЗначениеЗаполнено(ОшибкиЗаполнения) Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ФормированиеЭлектронногоДокумента

// Возвращаемое значение:
//  Дата
//
Функция ДатаФормирования() Экспорт
	Возврат ДатаФормирования;
КонецФункции

// Возвращаемое значение:
//  Строка
//
Функция ИдентификаторФайла() Экспорт
	ДополнительныеДанные = ПолучитьДополнительныеДанныеДляФормирования();
	ДанныеШаблона = Новый Структура;
	ДанныеШаблона.Вставить("ТипФайла", Менеджер.ПрефиксФормата());
	ДанныеШаблона.Вставить("Получатель", ДополнительныеДанные.Участники.ИдентификаторПолучателя);
	ДанныеШаблона.Вставить("Отправитель", ДополнительныеДанные.Участники.ИдентификаторОтправителя);
	ДанныеШаблона.Вставить("УИД", ДополнительныеДанные.УникальныйИдентификатор);
	ПредставлениеДаты = Формат(ДатаФормирования, "ДФ=yyyyMMdd");
	ДанныеШаблона.Вставить("Дата", ПредставлениеДаты);
	Возврат СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку("[ТипФайла]_[Получатель]_[Отправитель]_[Дата]_[УИД]",
		ДанныеШаблона);
КонецФункции

// Возвращаемое значение:
//  ФиксированнаяСтруктура:
// * Файл - Строка
// * Документ - Строка
// * ИдИнфПодр - Строка
// * СодФХЖ4 - Строка
// * СвПрием - Строка
// * ИтогУмСтоимДог - Строка
// * ИзвОРасч - Строка
// * ПодписантЗак - Строка
// * ИдРеквДокТип - Строка
// * РеквДокТип - Строка
// * ИдРекСостТип - Строка
// * ДаннИноТип - Строка
// * ПодписантТип - Строка
// * СвДовер - Строка
// * СвДоверБум - Строка
// * ДопПолеСтрИнфТип - Строка
// * ИнфПолТип - Строка
// * ТекстИнфТип - Строка
// * ФИОТип - Строка
// * ВремяТип - Строка
// * ДатаТип - Строка
// * ИННФЛТип - Строка
// * ИННЮЛТип - Строка
// * КНДТип - Строка
//
Функция ТипыОбъектов() Экспорт
	// BSLLS:Typo-off
	Типы = Новый Структура;
	ТипФайл = АнонимныйТип("Файл");
	Типы.Вставить("Файл", ТипФайл);
	ТипДокумент = АнонимныйТип("Файл.Документ");
	Типы.Вставить("Документ", ТипДокумент);
	ТипИнформацияПодрядчика = АнонимныйТип("Файл.Документ.ИдИнфПодр");
	Типы.Вставить("ИдИнфПодр", ТипИнформацияПодрядчика);
	ТипСодержаниеФХЖ = АнонимныйТип("Файл.Документ.СодФХЖ4");
	Типы.Вставить("СодФХЖ4", ТипСодержаниеФХЖ);
	ТипСведенияОПриемке = АнонимныйТип("Файл.Документ.СодФХЖ4.СвПрием");
	Типы.Вставить("СвПрием", ТипСведенияОПриемке);
	ТипИтогиДокумента = АнонимныйТип("Файл.Документ.СодФХЖ4.СвПрием.ИтогУмСтоимДог");
	Типы.Вставить("ИтогУмСтоимДог", ТипИтогиДокумента);
	ТипИзвещениеОРасчетах = АнонимныйТип("Файл.Документ.СодФХЖ4.ИзвОРасч");
	Типы.Вставить("ИзвОРасч", ТипИзвещениеОРасчетах);
	ТипПодписант = АнонимныйТип("Файл.Документ.ПодписантЗак");
	Типы.Вставить("ПодписантЗак", ТипПодписант);
	Типы.Вставить("ИдРеквДокТип", "ИдРеквДокТип");
	Типы.Вставить("РеквДокТип", "РеквДокТип");
	Типы.Вставить("ИдРекСостТип", "ИдРекСостТип");
	Типы.Вставить("ДаннИноТип", "ДаннИноТип");
	Типы.Вставить("ПодписантТип", "ПодписантТип");
	Типы.Вставить("СвДовер", "ПодписантТип.СвДовер");
	Типы.Вставить("СвДоверБум", "ПодписантТип.СвДоверБум");
	Типы.Вставить("ДопПолеСтрИнфТип", "ДопПолеСтрИнфТип");
	Типы.Вставить("ИнфПолТип", "ИнфПолТип");
	Типы.Вставить("ТекстИнфТип", "ТекстИнфТип");
	Типы.Вставить("ФИОТип", "ФИОТип");
	Типы.Вставить("ВремяТип", "ВремяТип");
	Типы.Вставить("ДатаТип", "ДатаТип");
	Типы.Вставить("ИННФЛТип", "ИННФЛТип");
	Типы.Вставить("ИННЮЛТип", "ИННЮЛТип");
	Типы.Вставить("КНДТип", "КНДТип");
	Возврат Новый ФиксированнаяСтруктура(Типы);
	// BSLLS:Typo-on
КонецФункции

// Параметры:
//  ТипОбъекта - Строка - см. ТипыОбъектов
// 
// Возвращаемое значение:
//  ОбъектXDTO
//
Функция ПолучитьXDTOОбъект(ТипОбъекта) Экспорт
	Возврат РаботаСФайламиБЭД.ПолучитьОбъектТипаCML(ТипОбъекта, ПространствоИмен);
КонецФункции

#КонецОбласти

#Область Общее

// см. ОбработкаМенеджер.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ПространствоИмен
//
Функция ПространствоИмен() Экспорт
	Возврат Менеджер.ПространствоИмен();
КонецФункции

// Параметры:
//  ДополнительныеДанные - см. ФорматыЭДО.НовыеДанныеДляФормированияОтветногоТитула
//
Процедура УстановитьДополнительныеДанныеДляФормирования(ДополнительныеДанные) Экспорт
	ДополнительныеДанныеДляФормирования = ДополнительныеДанные;
	ПараметрыОсновногоТитула = КонвертацияЭДО.ПолучитьПараметрыЭлектронногоДокумента(
		ДополнительныеДанные.Основание.ДвоичныеДанные);
КонецПроцедуры

// Возвращаемое значение:
//  см. ФорматыЭДО.НовыеДанныеДляФормированияОтветногоТитула
//
Функция ПолучитьДополнительныеДанныеДляФормирования() Экспорт
	Возврат ДополнительныеДанныеДляФормирования;
КонецФункции

// Возвращаемое значение:
//  Структура:
//  * ДатаФормированияФайла - Строка
//  * ВремяФормированияФайла - Строка
//  * НомерАкта - Строка
//  * ДатаАкта - Строка
//  * ИдентификаторФайла - Строка
//
Функция ПолучитьПараметрыОсновногоТитула() Экспорт
	Возврат ПараметрыОсновногоТитула;
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция АнонимныйТип(Тип)
	Возврат СтрШаблон("{%1}.%2", ПространствоИмен, Тип);
КонецФункции

Процедура Инициализировать()
	Менеджер = Обработки.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО;
	ПространствоИмен = ПространствоИмен();
	ДатаФормирования = ТекущаяДатаСеанса();
	ОбработчикОшибок.Инициализировать(ЭтотОбъект);
	ОшибкиЗаполнения = Новый Массив;
КонецПроцедуры

#КонецОбласти

#Область Инициализация

Инициализировать();

#КонецОбласти

#КонецЕсли
