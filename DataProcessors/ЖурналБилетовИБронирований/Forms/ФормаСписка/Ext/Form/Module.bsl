﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("КлючНазначенияФормы") И Не ПустаяСтрока(Параметры.КлючНазначенияФормы) Тогда
		КлючНазначенияИспользования = Параметры.КлючНазначенияФормы;
	Иначе
		КлючНазначенияИспользования = "ЭлектронныеБилетыИБронирования";
	КонецЕсли;
	
	Если КлючНазначенияИспользования = "ЭлектронныеБилетыИБронирования" Тогда
		КлючНастроек = "";
	Иначе
		КлючНастроек = КлючНазначенияИспользования;
	КонецЕсли;
	НавигационнаяСсылка = "e1cib/app/Обработка.ЖурналБилетовИБронирований";
	
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("ИдОбъектаБронирование",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.Бронирование"));
	
	// ПроверкаДокументовВРеглУчете
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	ЗаполнитьЗначенияСвойств(СвойстваСписка, СписокДокументов);
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокДокументов, СвойстваСписка);
	// Конец ПроверкаДокументовВРеглУчете
	
	УстановитьВидимостьДоступность();
	УстановитьОтборДинамическихСписков();
	НастроитьКнопкиУправленияДокументами();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов("ДокументСсылка.Бронирование");
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокДокументовКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ДополнительныеПараметры = Новый Структура("МестоРазмещенияДанныхПроверкиРегл", Элементы.ГруппаРеглПроверка);
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Период            = Настройки.Получить("Период");
	Организация       = Настройки.Получить("Организация");
	Сотрудник         = Настройки.Получить("Сотрудник");
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Бронирование" Тогда
		Элементы.СписокДокументов.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	УстановитьОтборДинамическихСписков();
КонецПроцедуры

&НаКлиенте
Процедура СотрудникОтборПриИзменении(Элемент)
	УстановитьОтборДинамическихСписков();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПриАктивизацииСтроки(Элемент)
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элемент);
	Иначе
		ПараметрыОснования = Новый Структура;
		ПараметрыОснования.Вставить("ТипБронирования", ПредопределенноеЗначение("Перечисление.ТипыБронирования.ЭлектронныйБилет"));
		ПараметрыОснования.Вставить("Организация", Организация);
		ПараметрыОснования.Вставить("Сотрудник", Сотрудник);
		
		ОткрытьФорму("Документ.Бронирование.Форма.ФормаДокумента", Новый Структура("Основание", ПараметрыОснования));
	КонецЕсли;
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элемент, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовСкопировать(Команда)
	
	ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элементы.СписокДокументов);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовОтменаПроведения(Команда)
	
	ОбщегоНазначенияУТКлиент.ОтменаПроведения(Элементы.СписокДокументов, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПровести(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.СписокДокументов, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовУстановитьСнятьПометкуУдаления(Команда)
	
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элементы.СписокДокументов, Заголовок);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокДокументов);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокДокументов, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокДокументов);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура СоздатьБилет(Команда)
	
	ПараметрыОснования = Новый Структура;
	ПараметрыОснования.Вставить("ТипБронирования", ПредопределенноеЗначение("Перечисление.ТипыБронирования.ЭлектронныйБилет"));
	ПараметрыОснования.Вставить("Организация", Организация);
	ПараметрыОснования.Вставить("Сотрудник", Сотрудник);
	
	ОткрытьФорму("Документ.Бронирование.Форма.ФормаДокумента", Новый Структура("Основание", ПараметрыОснования));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьБронирование(Команда)
	
	ПараметрыОснования = Новый Структура;
	ПараметрыОснования.Вставить("ТипБронирования", ПредопределенноеЗначение("Перечисление.ТипыБронирования.Бронирование"));
	
	ОткрытьФорму("Документ.Бронирование.Форма.ФормаДокумента", Новый Структура("Основание", ПараметрыОснования));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУтКлиент.РедактироватьПериод(Период,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Период = ВыбранноеЗначение;
	УстановитьОтборПоПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеБронирования(Команда)
	
	//++ Локализация
	ДлительнаяОперация = НачатьПолучениеДанныхБронированияНаСервере();
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьПолучениеДанныхБронирования", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	//-- Локализация
	
	Возврат;
	
КонецПроцедуры

//++ Локализация
&НаСервере
Функция НачатьПолучениеДанныхБронированияНаСервере()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияПроцедуры();
	ПараметрыВыполнения.КлючФоновогоЗадания = Метаданные.РегламентныеЗадания.ПолучениеДанныхСмартвей.Ключ;
	
	Возврат ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения, "ИнтеграцияСмартвей.ПолучитьДанныеБронирования");
	
КонецФункции

&НаКлиенте
Процедура ОбработатьПолучениеДанныхБронирования(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.СписокДокументов.Обновить();
	
КонецПроцедуры
//-- Локализация

&НаКлиенте
Процедура ОформитьКомандировку(Команда)
	
	//++ Локализация


	//-- Локализация
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокДокументов.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДокументов,
		"Организация",
		Организация,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Организация));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДокументов,
		"Сотрудник",
		Сотрудник,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Сотрудник));
		
	УстановитьОтборПоПериоду();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПериоду()
	
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("НачалоПериода", Период.ДатаНачала);
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("КонецПериода", Период.ДатаОкончания);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Элементы.ОрганизацияОтбор.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.Подразделение.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения");
	
	//++ Локализация
	Элементы.СписокПолучитьДанныеБронирования.Видимость = Истина;
	Элементы.СписокОформитьКомандировку.Видимость = Истина;
	//-- Локализация
	
КонецПроцедуры

&НаСервере
Процедура НастроитьКнопкиУправленияДокументами()
	
	ВидимостьКомандРедактирования = ПравоДоступа("Добавление", Метаданные.Документы.Бронирование);
	
	Если Не ВидимостьКомандРедактирования Тогда
		
		КомандыРедактирования = Новый Массив;
		КомандыРедактирования.Добавить(Элементы.СписокСоздатьБилет);
		КомандыРедактирования.Добавить(Элементы.СписокСоздатьБронирование);
		КомандыРедактирования.Добавить(Элементы.СписокСкопировать);
		КомандыРедактирования.Добавить(Элементы.СписокУстановитьСнятьПометкуУдаления);
		КомандыРедактирования.Добавить(Элементы.СписокПровести);
		КомандыРедактирования.Добавить(Элементы.СписокОтменаПроведения);
		КомандыРедактирования.Добавить(Элементы.СписокКонтекстноеМенюСкопировать);
		КомандыРедактирования.Добавить(Элементы.СписокКонтекстноеМенюУстановитьПометкуУдаления);
		КомандыРедактирования.Добавить(Элементы.СписокКонтекстноеМенюПровести);
		КомандыРедактирования.Добавить(Элементы.СписокКонтекстноеМенюОтменаПроведения);
		
		Для каждого КомандаРедактирования Из КомандыРедактирования Цикл
			КомандаРедактирования.Видимость = Ложь;
		КонецЦикла;
	КонецЕсли;
	
	//++ Локализация


	//-- Локализация
	
КонецПроцедуры

#КонецОбласти