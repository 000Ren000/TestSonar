﻿ #Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Обработки.ПанельАдминистрированияУТ) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав. Для настройки параметров раздела Казначейство и взаиморасчеты обратитесь к администратору.'");
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = НастройкиСистемыПовтИсп.ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	РежимРаботы = Новый Структура;
	
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьПодразделения");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьНесколькоОрганизаций");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьБюджетирование");
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	ИспользоватьЖурналПлатежей           = Число(НаборКонстант.ИспользоватьЖурналПлатежей);
	РежимРаспределенияВзаиморасчетов     = НаборКонстант.НоваяАрхитектураВзаиморасчетов;
	ЗачетОплатПоДатеПлатежа              = НаборКонстант.ЗачетОплатПоДатеПлатежа;
	РежимПечатиАвансовогоОтчета          = ЗначениеЗаполнено(НаборКонстант.ДатаНачалаПечатиЕдиногоАвансовогоОтчета);
	ПереоцениватьВалютныеСредстваПоДням  = НаборКонстант.ПереоцениватьВалютныеСредстваПоДням;
	НаименованиеФоновогоЗаданияПерехода  = НСтр("ru = 'Заполнение регистров расчетов в новой архитектуре'");
	
	Элементы.ГруппаАвансовыеОтчетыСпособПечати.Видимость = Константы.ВидимостьДатыНачалаПечатиЕдиногоАвансовогоОтчета.Получить();
	ТолькоНоваяАрхитектураВзаиморасчетов = НЕ ИспользовалисьОфлайнВзаиморасчеты() И РежимРаспределенияВзаиморасчетов;
	
	УстановитьСписокВыбораВариантаИспользованияЛимитов();
	ВариантИспользованияЛимитов = ЗначениеВыбораВариантИспользованияЛимитов(НаборКонстант);
	
	Элементы.ГруппаПеречислениеЗарплатыЧерезПереводыВПути.Видимость = Ложь;
	
	
	ЕстьНачислениеЗадолженности = ЕстьНачислениеЗадолженностиКорректировкой();
	ОрганизацииИспользующиеДисконтирование.ЗагрузитьЗначения(ОрганизацииИспользующиеДисконтирование());
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
	НастройкиСистемыЛокализация.ПриСозданииНаСервере_Казначейство(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗначенияПоУмолчанию = Новый Структура;
	
	НастройкиСистемыЛокализация.ПриЧтенииНаСервере_Казначейство(ЭтотОбъект);
	ОбщегоНазначенияУТКлиентСервер.СохранитьЗначенияДоИзменения(ЭтотОбъект);
	
	УстановитьСписокВыбораВариантаИспользованияЛимитов();
	ВариантИспользованияЛимитов = ЗначениеВыбораВариантИспользованияЛимитов(НаборКонстант);
	
КонецПроцедуры

// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
	 ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
	 		И ОбщегоНазначенияУТКлиентСервер.ПолучитьОбщиеКлючиСтруктур(
	 			Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		Прочитать();
		УстановитьДоступность();
		
		ДополнитьТекстРасширеннойПодсказкиВариантаИспользованияЛимитов();
		
	КонецЕсли;
	
	Если Источник = ЭтотОбъект Тогда
		Если Параметр.Свойство("Элемент") Тогда
			Подключаемый_ПриИзмененииРеквизита(Параметр.Элемент, Истина, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьДоговорыКредитовИДепозитовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНесколькоКассПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗаявкиНаРасходованиеДенежныхСредствПриИзменении(Элемент)
	
	Если НаборКонстант.ИспользоватьЗаказыПоставщикам И НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств Тогда
		
		УстановитьИспользованиеЗаказовПоставщикамИЗаявокНаРасходованиеДС(Истина);
		
	Иначе
		
		УстановитьИспользованиеЗаказовПоставщикамИЗаявокНаРасходованиеДС(Ложь);
		
	КонецЕсли;

	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЛимитыРасходаДенежныхСредствПоОрганизациямПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениямПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьПревышениеЛимитовРасходаДенежныхСредствПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЖурналПлатежейПриИзменении(Элемент)
	
	НаборКонстант.ИспользоватьЖурналПлатежей = ИспользоватьЖурналПлатежей;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОплатуПлатежнымиКартамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДоверенностиНаПолучениеТМЦПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСтатусыАвансовыхОтчетовПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьВыдачуПодОтчетВРазрезеЦелейПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗаявкиНаКомандировкуПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРеквизита(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура АктуализироватьДанныеПриФормированииОтчетовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура НоваяАрхитектураРасчетовПриИзменении(Элемент)
	
	ОчиститьСообщения();
	Если РежимРаспределенияВзаиморасчетов И НЕ НаборКонстант.НоваяАрхитектураВзаиморасчетов Тогда
		ТекстВопроса = НСтр("ru = 'ВНИМАНИЕ! Возврат на старую архитектуру больше не поддерживается.
		|Включение новой архитектуры может занять продолжительное время.
		|Продолжить?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("НоваяАрхитектураРасчетовВключениеЗавершение", ЭтотОбъект), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокЗачетаДокументовПриИзменении(Элемент)
	
	НаборКонстант.ЗачетОплатПоДатеПлатежа = ЗачетОплатПоДатеПлатежа;
	СохранитьЗначениеРеквизита("НаборКонстант.ЗачетОплатПоДатеПлатежа");
	
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьПланыФоновымЗаданиемПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьОстаткиАвансовКлиентовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПереоцениватьВалютныеСредстваПоДнямПриИзменении(Элемент)
	
	НаборКонстант.ПереоцениватьВалютныеСредстваПоДням = ПереоцениватьВалютныеСредстваПоДням;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПечатиЕдиногоАвансовогоОтчетаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура РежимПечатиЕдиногоАвансовогоОтчетаПриИзменении(Элемент)
	
	Если Не РежимПечатиАвансовогоОтчета Тогда
		НаборКонстант.ДатаНачалаПечатиЕдиногоАвансовогоОтчета = Неопределено;
		Подключаемый_ПриИзмененииРеквизита(Элементы.ДатаНачалаПечатиЕдиногоАвансовогоОтчета);
	КонецЕсли;
	
	УстановитьДоступность("РежимПечатиАвансовогоОтчета");
	
КонецПроцедуры

&НаКлиенте
Процедура МеждународныеБанковскиеРеквизитыПриИзменении(Элемент)
	
	ПриИзмененииРеквизита(Элемент)

КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПеречисленияЗарплатыЧерезПереводыВПутиПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеречислятьЗарплатуЧерезПромежуточныйСчетПереводыВПутиПриИзменении(Элемент)
	
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНесколькоКлассификацийЗадолженностиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВариантИспользованияЛимитовПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьВариантыКлассификацииЗадолженности(Команда)
	
	ОткрытьФорму("Справочник.ВариантыКлассификацииЗадолженности.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСвойстваКлассификацииЗадолженности(Команда)
	
	ОткрытьФорму("Справочник.ВариантыКлассификацииЗадолженности.ФормаОбъекта",
		Новый Структура("Ключ", ОбщегоНазначенияУТВызовСервера.ВариантКлассификацииЗадолженностиПоУмолчанию()),
		ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина, ВнешнееИзменение = Ложь)
	
	Если НЕ ВнешнееИзменение Тогда
		НастройкиСистемыКлиентЛокализация.ПриИзмененииРеквизита_Казначейство(
			Элемент,
			ЭтотОбъект);
	КонецЕсли;
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаНавигационнойСсылкиФормы(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиСистемыКлиентЛокализация.ОбработкаНавигационнойСсылкиФормы_Казначейство(Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗаданияРаспределения()
	Попытка
		
		Если ФормаДлительнойОперации.Открыта()
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				РаспределениеВыполнено();
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗаданияРаспределения", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
			КонецЕсли;
		Иначе
			РежимРаспределенияВзаиморасчетов = Ложь;
		КонецЕсли;
		
	Исключение
		
		РежимРаспределенияВзаиморасчетов = Ложь;
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределениеВыполнено()
	
	Результат = ЗаполнитьРегистрыРасчетовНаСервере();
	Если Результат.Статус = "Выполняется" Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания;
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала = 1.2; // Уменьшим шаг увеличения времени опроса выполнения задания
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		НаборКонстант.НоваяАрхитектураВзаиморасчетов = Ложь;
		РежимРаспределенияВзаиморасчетов = Ложь;
		УстановитьДоступность();
		ВызватьИсключение Результат.ПодробноеПредставлениеОшибки;
	Иначе
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		НаборКонстант.НоваяАрхитектураВзаиморасчетов = РежимРаспределенияВзаиморасчетов;
		СохранитьЗначениеРеквизита("НаборКонстант.НоваяАрхитектураВзаиморасчетов");
		УстановитьДоступность();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				НаборКонстант.НоваяАрхитектураВзаиморасчетов = РежимРаспределенияВзаиморасчетов;
				СохранитьЗначениеРеквизита("НаборКонстант.НоваяАрхитектураВзаиморасчетов");
				УстановитьДоступность();
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		
		РежимРаспределенияВзаиморасчетов = Ложь;
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если СтрНачинаетсяС(НРег(РеквизитПутьКДанным), НРег("НаборКонстант.")) Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
		КонстантаИмя = ЧастиИмени[1];
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
		Если РеквизитПутьКДанным = "ИспользоватьЖурналПлатежей" Тогда
			КонстантаИмя = "ИспользоватьЖурналПлатежей";
			НаборКонстант.ИспользоватьЖурналПлатежей = Булево(ИспользоватьЖурналПлатежей);
		КонецЕсли;
		
		Если РеквизитПутьКДанным = "ПереоцениватьВалютныеСредстваПоДням" Тогда
			КонстантаИмя = "ПереоцениватьВалютныеСредстваПоДням";
			НаборКонстант.ПереоцениватьВалютныеСредстваПоДням = Булево(ПереоцениватьВалютныеСредстваПоДням);
		КонецЕсли;
		
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если НастройкиСистемыПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств" Тогда
		ИспользоватьЖурналПлатежей = Число(НаборКонстант.ИспользоватьЖурналПлатежей);
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "ВариантИспользованияЛимитов" Тогда
		Если ВариантИспользованияЛимитов = "" Тогда
			КонстантаМенеджер = Константы["ИспользоватьЛимитыРасходаДенежныхСредств"];
			КонстантаМенеджер.Установить(Ложь);
			КонстантаМенеджер = Константы["ИспользоватьЛимитыРасходаДенежныхСредствПоОрганизациям"];
			КонстантаМенеджер.Установить(Ложь);
			КонстантаМенеджер = Константы["ИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениям"];
			КонстантаМенеджер.Установить(Ложь);
			КонстантаМенеджер = Константы["КонтролироватьПревышениеЛимитовРасходаДенежныхСредств"];
			КонстантаМенеджер.Установить(Ложь);
		ИначеЕсли ВариантИспользованияЛимитов = "ДокументЛимитов" Тогда 
			КонстантаМенеджер = Константы["ИспользоватьЛимитыРасходаДенежныхСредств"];
			КонстантаМенеджер.Установить(Истина);
			КонстантаМенеджер = Константы["КонтролироватьПревышениеЛимитовРасходаДенежныхСредств"];
			КонстантаМенеджер.Установить(Истина);

		КонецЕсли;
		Прочитать();
	КонецЕсли;
	
	НастройкиСистемыЛокализация.СохранитьЗначениеРеквизита_НастройкиНоменклатуры(КонстантаИмя, КонстантаЗначение, ЭтотОбъект);
	
	Возврат КонстантаИмя
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")

	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств"
		Или РеквизитПутьКДанным = "ВариантИспользованияЛимитов"
		Или РеквизитПутьКДанным = "" Тогда
		
		Элементы.ИспользоватьНесколькоКасс.Доступность = НЕ НаборКонстант.ИспользоватьНесколькоОрганизаций;
		
		Если ВариантИспользованияЛимитов = "" Тогда
			Элементы.ГруппаИспользоватьЛимитыРасходаДенежныхСредствПоОрганизациям.Видимость = Ложь;
			Элементы.ГруппаИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениям.Видимость = Ложь;
			Элементы.ГруппаКонтролироватьПревышениеЛимитовРасходаДенежныхСредств.Видимость = Ложь;
			Элементы.ГруппаСправочникМоделиБюджетирования.Видимость = Ложь;
		ИначеЕсли ВариантИспользованияЛимитов = "ДокументЛимитов" Тогда
			Элементы.ГруппаИспользоватьЛимитыРасходаДенежныхСредствПоОрганизациям.Видимость = Истина;
			Элементы.ГруппаИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениям.Видимость = Истина;
			Элементы.ГруппаКонтролироватьПревышениеЛимитовРасходаДенежныхСредств.Видимость = Истина;
			Элементы.ГруппаСправочникМоделиБюджетирования.Видимость = Ложь;
		КонецЕсли;
		
		Элементы.ВариантИспользованияЛимитов.Доступность = НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств;
		ДополнитьТекстРасширеннойПодсказкиВариантаИспользованияЛимитов();
		
		Элементы.ИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениям.Доступность = НаборКонстант.ИспользоватьПодразделения;
		Элементы.ПереоцениватьВалютныеСредстваПоДням.Видимость = НаборКонстант.ИспользоватьНесколькоВалют;
		
		Элементы.АктуализироватьВзаиморасчетыВДокументах.Видимость = НЕ ТолькоНоваяАрхитектураВзаиморасчетов;
		Элементы.АктуализироватьВзаиморасчетыВОтчетах.Видимость = НЕ ТолькоНоваяАрхитектураВзаиморасчетов;
		Элементы.НоваяАрхитектураВзаиморасчетов.Видимость = НЕ ТолькоНоваяАрхитектураВзаиморасчетов;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНесколькоКасс" ИЛИ РеквизитПутьКДанным = "" Тогда
		Если НаборКонстант.ИспользоватьНесколькоКасс Тогда
			Элементы.ГруппаСтраницыИспользоватьНесколькоКасс.ТекущаяСтраница = Элементы.ГруппаНесколькоКасс;
		Иначе
			Элементы.ГруппаСтраницыИспользоватьНесколькоКасс.ТекущаяСтраница = Элементы.ГруппаОднаКасса;
		КонецЕсли;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНесколькоРасчетныхСчетов" ИЛИ РеквизитПутьКДанным = "" Тогда
		Если НаборКонстант.ИспользоватьНесколькоРасчетныхСчетов Тогда
			Элементы.ГруппаСтраницыИспользоватьНесколькоРасчетныхСчетов.ТекущаяСтраница = Элементы.ГруппаНесколькоСчетов;
		Иначе
			Элементы.ГруппаСтраницыИспользоватьНесколькоРасчетныхСчетов.ТекущаяСтраница = Элементы.ГруппаОдинСчет;
		КонецЕсли;
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств"
		Или РеквизитПутьКДанным = "" Тогда
		Элементы.ИспользоватьЖурналПлатежей.Доступность = Не НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.НоваяАрхитектураВзаиморасчетов"
		Или РеквизитПутьКДанным = "" Тогда
		
		Элементы.АктуализироватьВзаиморасчетыВДокументах.Видимость = НЕ НаборКонстант.НоваяАрхитектураВзаиморасчетов;
		Элементы.АктуализироватьВзаиморасчетыВОтчетах.Видимость = НЕ НаборКонстант.НоваяАрхитектураВзаиморасчетов;
		Элементы.РаспределятьПлановыеРасчетыФоновымЗаданием.Доступность = НаборКонстант.НоваяАрхитектураВзаиморасчетов;
		 
		Отбор = Новый Структура("Наименование, Состояние");
		Отбор.Наименование = НаименованиеФоновогоЗаданияПерехода;
		Отбор.Состояние = СостояниеФоновогоЗадания.Активно;
		ЗаданияПереносаРасчетов = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
		
		ОбновленыРегистрыРасчетов = ОбновлениеИнформационнойБазы.ОбъектОбработан("РасчетыСКлиентами").Обработан
			И ОбновлениеИнформационнойБазы.ОбъектОбработан("РасчетыСПоставщиками").Обработан
			И ОбновлениеИнформационнойБазы.ОбъектОбработан("РасчетыСКлиентамиПоДокументам").Обработан
			И ОбновлениеИнформационнойБазы.ОбъектОбработан("РасчетыСПоставщикамиПоДокументам").Обработан;
			
		ДоступноВыключениеНовойАрхитектуры = Истина;
		ЕстьДисконтирование = Ложь;
		Если РежимРаспределенияВзаиморасчетов Тогда
			Если ОрганизацииИспользующиеДисконтирование.Количество() > 0 Тогда
				ДоступноВыключениеНовойАрхитектуры = Ложь;
				ЕстьДисконтирование = Истина;
				ТекстКомментария = НСтр("ru = 'Переход на Офлайн взаиморасчеты невозможен, так как включено дисконтирование кредиторской задолженности в организациях:'");
				ТекстКомментария = ТекстКомментария + " " + СтрСоединить(ОрганизацииИспользующиеДисконтирование.ВыгрузитьЗначения(), ", ") + ".";
			КонецЕсли;
			
			Если ЕстьНачислениеЗадолженности Тогда
				ДоступноВыключениеНовойАрхитектуры = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		ДоступноВключениеНовойАрхитектуры = ОбновленыРегистрыРасчетов И ЗаданияПереносаРасчетов.Количество() = 0;
		Элементы.НоваяАрхитектураВзаиморасчетов.Доступность = ДоступноВключениеНовойАрхитектуры И ДоступноВыключениеНовойАрхитектуры;
		Элементы.КомментарийИспользованияДисконтирования.Заголовок = ТекстКомментария;
		Элементы.ГруппаКомментарийИспользованияДисконтирования.Видимость = ЕстьДисконтирование;
		Элементы.ГруппаКомментарийИспользованияНачисленийВКорректировках.Видимость = ЕстьНачислениеЗадолженности;
		
		ТекстКомментария = НСтр("ru = 'Не закончено отложенное обновление регистров взаиморасчетов.'");
		Если ЗаданияПереносаРасчетов.Количество() > 0 Тогда
			ТекстКомментария = НСтр("ru = 'Выполняется перенос данных взаиморасчетов на новую архитектуру.'");
		КонецЕсли;
		Элементы.КомментарийПереходаНаНовуюАрхитектуру.Заголовок = ТекстКомментария;
		Элементы.ГруппаКомментарийПереходаНаНовуюАрхитектуру.Видимость = НЕ ДоступноВключениеНовойАрхитектуры;
		
		Элементы.ГруппаПереходНаНовуюАрхитектуру.Видимость = НЕ НаборКонстант.НоваяАрхитектураВзаиморасчетов;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.МеждународныеРеквизитыБанковскихСчетов" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ГруппаПлатежиВВалюте.Доступность = НаборКонстант.МеждународныеРеквизитыБанковскихСчетов;
	КонецЕсли;
		
	Элементы.ЗачетОплатПоДатеПлатежа.Доступность = РежимРаспределенияВзаиморасчетов;
	Если РеквизитПутьКДанным = "РежимПечатиАвансовогоОтчета" Или РеквизитПутьКДанным = "" Тогда
		Элементы.ДатаНачалаПечатиЕдиногоАвансовогоОтчета.Доступность = РежимПечатиАвансовогоОтчета;
	КонецЕсли;
	
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНесколькоКлассификацийЗадолженности" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Если НаборКонстант.ИспользоватьНесколькоКлассификацийЗадолженности Тогда
			Элементы.ГруппаКлассификацияЗадолженностейПраво.ТекущаяСтраница = Элементы.ГруппаКлассификацияЗадолженностейПравоНесколькоВариантов;
		Иначе
			Элементы.ГруппаКлассификацияЗадолженностейПраво.ТекущаяСтраница = Элементы.ГруппаКлассификацияЗадолженностейПравоОдинВариант;
		КонецЕсли;

	КонецЕсли;
	
	ОбменДаннымиУТУП.УстановитьДоступностьНастроекУзлаИнформационнойБазы(ЭтотОбъект);
	ОтображениеПредупрежденияПриРедактировании(РеквизитПутьКДанным);
	
	НастройкиСистемыЛокализация.УстановитьДоступность_Казначейство(РеквизитПутьКДанным, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОтображениеПредупрежденияПриРедактировании(РеквизитПутьКДанным)
	
	СтруктураКонстант = Новый Структура();
	
	НастройкиСистемыЛокализация.ОтображениеПредупрежденияПриРедактировании_Казначейство(СтруктураКонстант);
	
	Для Каждого КлючИЗначение Из СтруктураКонстант Цикл
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы[КлючИЗначение.Ключ],
			НаборКонстант[КлючИЗначение.Ключ]);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИспользованиеЗаказовПоставщикамИЗаявокНаРасходованиеДС(Использование)
	
	Константы.ИспользоватьЗаказыПоставщикамИЗаявкиНаРасходованиеДС.Установить(Использование);
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьРегистрыРасчетовНаСервере()
	
	ПараметрыЭкспортнойПроцедуры = Новый Структура;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеФоновогоЗаданияПерехода;
	
	Результат = ДлительныеОперации.ВыполнитьВФоне(
		"ОперативныеВзаиморасчетыСервер.ЗаполнитьРегистрыПриВключенииНовойАрхитектуры",
		ПараметрыЭкспортнойПроцедуры,
		ПараметрыВыполнения);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЗапуститьРаспределениеРасчетовФоновымЗаданием ()
	
	ПараметрыЭкспортнойПроцедуры = Новый Структура;
	ПараметрыЭкспортнойПроцедуры.Вставить("ОкончаниеПериодаРасчета", ТекущаяДатаСеанса());
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания =НСтр("ru = 'Выполняется распределение офлайн расчетов'");
	
	Результат = ДлительныеОперации.ВыполнитьВФоне(
		"ОперативныеВзаиморасчетыСервер.РассчитатьВсе",
		ПараметрыЭкспортнойПроцедуры,
		ПараметрыВыполнения);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Функция ИспользовалисьОфлайнВзаиморасчеты()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|1 КАК Поле
	|ИЗ РегистрНакопления.РасчетыСКлиентамиПоДокументам КАК РасчетыСКлиентамиПоДокументам
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|1 КАК Поле
	|ИЗ РегистрНакопления.РасчетыСПоставщикамиПоДокументам КАК РасчетыСПоставщикамиПоДокументам
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|1 КАК Поле
	|ИЗ РегистрСведений.ЗаданияКРаспределениюРасчетовСКлиентами КАК ЗаданияКРаспределениюРасчетовСКлиентами
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|1 КАК Поле
	|ИЗ РегистрСведений.ЗаданияКРаспределениюРасчетовСПоставщиками КАК ЗаданияКРаспределениюРасчетовСПоставщиками";
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции

&НаСервере
Процедура УстановитьСписокВыбораВариантаИспользованияЛимитов()
	СписокВыбора = Элементы.ВариантИспользованияЛимитов.СписокВыбора;
	
	ЗначениеВыбора = "";
	Если СписокВыбора.НайтиПоЗначению(ЗначениеВыбора) = Неопределено Тогда
		ПредставлениеЗначения = НСтр("ru = 'Не используются'");
		СписокВыбора.Добавить(ЗначениеВыбора, ПредставлениеЗначения);
	КонецЕсли;
	
	ЗначениеВыбора = "ДокументЛимитов";
	Если СписокВыбора.НайтиПоЗначению(ЗначениеВыбора) = Неопределено Тогда
		ПредставлениеЗначения = НСтр("ru = 'По документам лимитов расхода ДС'");
		СписокВыбора.Добавить(ЗначениеВыбора, ПредставлениеЗначения);
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьТекстРасширеннойПодсказкиВариантаИспользованияЛимитов()
	
	Если ВариантИспользованияЛимитов = "" Тогда
		ТекстЗаголовка = НСтр("ru = 'Лимиты расхода денежных средств не используются.'");
	ИначеЕсли ВариантИспользованияЛимитов = "ДокументЛимитов" Тогда
		ТекстЗаголовка = НСтр("ru = 'Лимиты задаются документом ""Лимиты расхода денежных средств"".'");
	КонецЕсли;
	
	Элементы.ВариантИспользованияЛимитовПодсказка.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры

&НаКлиенте
Процедура НоваяАрхитектураРасчетовВключениеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Результат = ЗапуститьРаспределениеРасчетовФоновымЗаданием();
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтотОбъект, ИдентификаторЗадания);
		Если Результат.Статус = "Выполняется" Тогда
			ИдентификаторЗадания = Результат.ИдентификаторЗадания;
			ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания;
			ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала = 1.2; // Уменьшим шаг увеличения времени опроса выполнения задания
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗаданияРаспределения", 1, Истина);
		Иначе
			РаспределениеВыполнено();
		КонецЕсли;
	Иначе
		РежимРаспределенияВзаиморасчетов = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеВыбораВариантИспользованияЛимитов(НаборКонстант)
	
	Значение = "";
	Если НаборКонстант.ИспользоватьЛимитыРасходаДенежныхСредств Тогда
		Значение = "ДокументЛимитов";
	КонецЕсли;
	
	Возврат Значение;
КонецФункции

// Ищет организации, в которых включено дисконтирование кредиторской задолженности
// 
// Возвращаемое значение:
//  Массив из СправочникСсылка.Организации - найденные организации
&НаСервереБезКонтекста
Функция ОрганизацииИспользующиеДисконтирование()
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	УчетнаяПолитикаФинансовогоУчетаСрезПоследних.Организация
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаФинансовогоУчета.СрезПоследних КАК УчетнаяПолитикаФинансовогоУчетаСрезПоследних
	|ГДЕ
	|	УчетнаяПолитикаФинансовогоУчетаСрезПоследних.УчетДисконтированнойКредиторскойЗадолженностиПоставщикам";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Результат.Добавить(Выборка.Организация);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Проверяет наличие документа Корректировка задолженности с флагом ЭтоНачисление
// 
// Возвращаемое значение:
//  Булево - Истина, если такие документы есть в базе
&НаСервере
Функция ЕстьНачислениеЗадолженностиКорректировкой()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КорректировкаЗадолженности.Ссылка
	|ИЗ
	|	Документ.КорректировкаЗадолженности КАК КорректировкаЗадолженности
	|ГДЕ
	|	КорректировкаЗадолженности.ЭтоНачисление";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти
