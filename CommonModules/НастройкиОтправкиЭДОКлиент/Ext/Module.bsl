﻿
#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму настроек отправки электронных документов.
// 
// Параметры:
// 	ПараметрыФормы - см. НовыеПараметрыФормыНастроекОтправки
// 	ПараметрыОткрытия - см. ОбщегоНазначенияБЭДКлиент.ОткрытьФормуБЭД.ПараметрыОткрытияФормы
Процедура ОткрытьНастройкуОтправки(ПараметрыФормы, ПараметрыОткрытия = Неопределено) Экспорт
	
	Если ПараметрыОткрытия = Неопределено Тогда
		ПараметрыОткрытия = ОбщегоНазначенияБЭДКлиент.НовыеПараметрыОткрытияФормы();
		ПараметрыОткрытия.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	ОбщегоНазначенияБЭДКлиент.ОткрытьФормуБЭД(
		"РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.Форма.НастройкиОтправкиДокументов",
		ПараметрыФормы, ПараметрыОткрытия, Истина);
	
КонецПроцедуры

// Открывает форму списка настроек отправки электронных документов.
// 
// Параметры:
// 	Контрагент - ОпределяемыйТип.КонтрагентБЭД
Процедура ОткрытьНастройкиОтправки(Контрагент) Экспорт
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Контрагент", Контрагент);
	
	ОткрытьФорму("РегистрСведений.НастройкиОтправкиЭлектронныхДокументов.Форма.НастройкиОтправки",
		ПараметрыОткрытия,, Контрагент,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Возвращает параметры формы настроек отправки, см. ОткрытьНастройкиОтправки.
// 
// Возвращаемое значение:
// 	Структура:
// * КлючНастроекОтправки - см. НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки - свойства ВидДокумента, Организация,
//                          Договор не обязательны для заполнения
// * Создание - Булево
// * СоздатьПоДоговору - Неопределено
Функция НовыеПараметрыФормыНастроекОтправки() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("КлючНастроекОтправки", НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки());
	Параметры.Вставить("Создание", Ложь);
	Параметры.Вставить("СоздатьПоДоговору", Неопределено);
	
	Возврат Параметры;
	
КонецФункции

// Открывает форму списка настроек интеркампани.
//
// Параметры:
//  Организация -ОпределяемыйТип.ОрганизацияБЭД - Организация
Процедура ОткрытьНастройкиИнтеркампани(Организация) Экспорт
	
	ПараметрыОткрытия = Новый Структура("Организация", Организация);
	
	ОткрытьФорму("РегистрСведений.НастройкиОтправкиЭлектронныхДокументов.Форма.НастройкиОтправкиИнтеркампани",
		ПараметрыОткрытия,, Организация);
		
КонецПроцедуры

// Открывает форму настроек отправки электронных документов интеркампани.
// 
// Параметры:
// 	ПараметрыФормы - см. НовыеПараметрыФормыНастроекИнтеркампани
// 	ПараметрыОткрытия - см. ОбщегоНазначенияБЭДКлиент.ОткрытьФормуБЭД.ПараметрыОткрытияФормы
Процедура ОткрытьНастройкуИнтеркампани(ПараметрыФормы, ПараметрыОткрытия = Неопределено) Экспорт
	
	Если ПараметрыОткрытия = Неопределено Тогда
		ПараметрыОткрытия = ОбщегоНазначенияБЭДКлиент.НовыеПараметрыОткрытияФормы();
		ПараметрыОткрытия.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	ОбщегоНазначенияБЭДКлиент.ОткрытьФормуБЭД(
		"РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.Форма.НастройкиОтправкиДокументовИнтеркампани",
		ПараметрыФормы, ПараметрыОткрытия);
	
КонецПроцедуры

// Возвращает параметры формы настроек интеркампани, см. ОткрытьНастройкиИнтеркампани.
// 
// Параметры:
// 	Параметры
// Возвращаемое значение:
// 	Структура:
// * Отправитель - ОпределяемыйТип.Организация
// * Получатель - ОпределяемыйТип.КонтрагентБЭД
// * Создание - Булево
Функция НовыеПараметрыФормыНастроекИнтеркампани() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Отправитель");
	Параметры.Вставить("Получатель");
	Параметры.Вставить("Создание", Ложь);
	
	Возврат Параметры;
	
КонецФункции

// Открывает форму настройки отправки по договору, а если настроек нет - форму списка настроек.
//
// Параметры:
//  Договор - ОпределяемыйТип.ДоговорыКонтрагентов - Договор
Процедура ОткрытьНастройкиОтправкиПоДоговору(Договор) Экспорт
	
	НастройкаПоДоговору = НастройкиОтправкиЭДОСлужебныйВызовСервера.НастройкаПоДоговоруКонтрагента(Договор);
	
	Если НастройкаПоДоговору.ВладелецДоговора = Неопределено Тогда
		
		ПараметрыФормы = НовыеПараметрыФормыНастроекОтправки();
		ПараметрыФормы.КлючНастроекОтправки = НастройкаПоДоговору.КлючНастроекОтправки;
		ОткрытьНастройкуОтправки(ПараметрыФормы);
		
	Иначе
		
		ОткрытьНастройкиОтправки(НастройкаПоДоговору.ВладелецДоговора);
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает настройку прямого обмена.
// 
// Параметры:
// 	ПараметрыФормы - см. НовыеПараметрыФормыНастройкиПрямогоОбмена
// 	ПараметрыОткрытия - см. ОбщегоНазначенияБЭДКлиент.ОткрытьФормуБЭД.ПараметрыОткрытияФормы
Процедура ОткрытьНастройкуПрямогоОбмена(ПараметрыФормы, ПараметрыОткрытия = Неопределено) Экспорт
	
	Если ПараметрыОткрытия = Неопределено Тогда
		ПараметрыОткрытия = ОбщегоНазначенияБЭДКлиент.НовыеПараметрыОткрытияФормы();
		ПараметрыОткрытия.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	ОбщегоНазначенияБЭДКлиент.ОткрытьФормуБЭД(
		"РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.Форма.НастройкиОтправкиДокументовПрямойОбмен",
		ПараметрыФормы, ПараметрыОткрытия);
	
КонецПроцедуры

// Возвращает параметры формы настройки прямого обмена, см. ОткрытьНастройкуПрямогоОбмена.
// 
// Параметры:
// 	Параметры
// Возвращаемое значение:
// 	Структура - Описание:
// * Организация - ОпределяемыйТип.Организация
// * Контрагент - ОпределяемыйТип.КонтрагентБЭД
// * Договор - ОпределяемыйТип.ДоговорСКонтрагентомЭДО
Функция НовыеПараметрыФормыНастройкиПрямогоОбмена() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Организация");
	Параметры.Вставить("Контрагент");
	Параметры.Вставить("Договор");
	
	Возврат Параметры;
	
КонецФункции

// Открывает форму настройки заполнения дополнительных полей.
// 
// Параметры:
// 	ПараметрОткрытия - см. НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки
// 	                   см. НастройкиЭДОКлиентСервер.НоваяНастройкаОтправки
// 	Оповещение - ОписаниеОповещения
Процедура ОткрытьНастройкиЗаполненияДополнительныхПолей(ПараметрОткрытия, Оповещение = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПараметрОткрытия", ПараметрОткрытия);
	
	ОткрытьФорму("Обработка.НастройкиОтправкиЭДО.Форма.НастройкаЗаполненияДополнительныхПолей",
		ПараметрыФормы, ЭтотОбъект,,,,Оповещение);
		
КонецПроцедуры

// Открывает форму транспортных настроек отправки (выбор учетных записей).
// 
// Параметры:
// 	ПараметрыВыбора - см. НовыеПараметрыТранспортныхНастроек
// 	Владелец - Произвольный
// 	Оповещение - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана
//               после завершения настройки со следующими параметрами:
//    * Настройка - Неопределено
//                - см. НастройкиЭДОКлиентСервер.НоваяНастройкаОтправки.
//    * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта ОписаниеОповещения.
// 	Настройки - см. НастройкиЭДОКлиентСервер.НоваяНастройкаОтправки
Процедура ОткрытьТранспортныеНастройкиОтправки(ПараметрыВыбора, Владелец = Неопределено, Оповещение = Неопределено,
	Настройки = Неопределено) Экспорт
	
	НастройкиОтправкиЭДОСлужебныйКлиент.ОткрытьТранспортныеНастройкиОтправки(ПараметрыВыбора, Владелец, Оповещение,
		Настройки);
	
КонецПроцедуры

// Возвращает параметры настройки регламента ЭДО.
// 
// Возвращаемое значение:
// 	Структура:
// * КлючНастроек - см. НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки
// * ИдентификаторОтправителя - Строка
// * ИдентификаторПолучателя - Строка
// * НастройкаДокумента - Булево
// * ВыборУчетныхЗаписей - Булево - (служебное поле)
Функция НовыеПараметрыТранспортныхНастроек() Экспорт
	
	Возврат НастройкиОтправкиЭДОСлужебныйКлиент.НовыеПараметрыТранспортныхНастроек();
	
КонецФункции

// Выполняет настройку регламента ЭДО.
// 
// Параметры:
// 	КлючНастроек - см. НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки
// 	Владелец - Произвольный
// 	Оповещение - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана
//               после завершения настройки со следующими параметрами:
//    * Настройка - Неопределено
//                - см. НастройкиЭДОКлиентСервер.НоваяНастройкаОтправки.
//    * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта ОписаниеОповещения.
// 	НастройкаДокумента - Булево
// 	Настройки - см. НастройкиЭДОКлиентСервер.НоваяНастройкаОтправки
Процедура НастроитьРегламентЭДО(КлючНастроек, Владелец, Оповещение = Неопределено, НастройкаДокумента = Ложь,
	Настройки = Неопределено) Экспорт
	
	ПараметрыНастройки = НастройкиОтправкиЭДОСлужебныйКлиент.НовыеПараметрыНастройкиРегламентаЭДО();
	ПараметрыНастройки.КлючНастроек = КлючНастроек;
	ПараметрыНастройки.НастройкаДокумента = НастройкаДокумента;
	
	Если Настройки = Неопределено Тогда
		Настройки = НастройкиОтправкиЭДОСлужебныйВызовСервера.НастройкиОтправки(КлючНастроек);
	КонецЕсли;
	
	Если Настройки <> Неопределено Тогда
		ПараметрыНастройки.ИдентификаторОтправителя = Настройки.ИдентификаторОтправителя;
		ПараметрыНастройки.ИдентификаторПолучателя = Настройки.ИдентификаторПолучателя;
		ПараметрыНастройки.МаршрутПодписания = Настройки.МаршрутПодписания;
		ПараметрыНастройки.Формат = Настройки.Формат;
		ПараметрыНастройки.ТребуетсяИзвещение = Настройки.ТребуетсяИзвещениеОПолучении;
		ПараметрыНастройки.ТребуетсяПодтверждение = Настройки.ТребуетсяОтветнаяПодпись;
		ПараметрыНастройки.ВыгружатьДопСведения = Настройки.ВыгружатьДополнительныеСведения;
		ПараметрыНастройки.ЗаполнениеКодаТовара = Настройки.ЗаполнениеКодаТовара;
		ПараметрыНастройки.ВерсияФорматаУстановленаВручную = Настройки.ВерсияФорматаУстановленаВручную;
		ПараметрыНастройки.СпособОбмена = Настройки.СпособОбмена;
		ПараметрыНастройки.Формировать = Настройки.Формировать;
		ПараметрыНастройки.ОбменБезПодписи = Настройки.ОбменБезПодписи;
	КонецЕсли;
	
	НастройкиОтправкиЭДОСлужебныйКлиент.НастроитьРегламентЭДО(ПараметрыНастройки, Владелец, Оповещение);
	
КонецПроцедуры

#КонецОбласти