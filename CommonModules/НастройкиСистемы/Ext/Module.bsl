﻿////////////////////////////////////////////////////////////////////////////////
// Серверные процедуры и функции, управляющие настройками системы
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик подписки на событие ПриЗаписиКонстанты.
//
Процедура ПриЗаписиКонстанты(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеКонстанты = Источник.ЭтотОбъект.Метаданные(); //ОбъектМетаданных - 
	ИмяКонстанты		= МетаданныеКонстанты.Имя;
	ЗначениеКонстанты 	= Источник.Значение;
	
	// При включении разделенного режима, сбрасывается кэш значений констант, 
	// т.к. при установки зависимых констант идет проверка режима работы, для фильтрации неразделенных констант.
	Если ИмяКонстанты = "ИспользоватьРазделениеПоОбластямДанных"
		ИЛИ ИмяКонстанты = "НеИспользоватьРазделениеПоОбластямДанных"
		ИЛИ ИмяКонстанты = "НеИспользоватьРазделениеПоОбластямДанныхИЭтоКА"
		ИЛИ ИмяКонстанты = "НеИспользоватьРазделениеПоОбластямДанныхИЭтоУТ" Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	СинхронизироватьЗначенияПодчиненныхКонстант(ИмяКонстанты, ЗначениеКонстанты, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает имя макета с правилами обмена.
// Имя можно переопределить в целях локализации.
// 
// Возвращаемое значение:
// 	Строка - имя правил обмена.
Функция ИмяПравилОбменаПомощникВыгрузкиЗагрузкиМоделиМеждународногоУчета() Экспорт
	
	Если Метаданные.ВариантВстроенногоЯзыка = Метаданные.СвойстваОбъектов.ВариантВстроенногоЯзыка.Русский Тогда
		ИмяПравилОбмена = "ПравилаОбменаБазовые_ru";
	ИначеЕсли Метаданные.ВариантВстроенногоЯзыка = Метаданные.СвойстваОбъектов.ВариантВстроенногоЯзыка.Английский Тогда
		ИмяПравилОбмена = "ПравилаОбменаБазовые_en";
	КонецЕсли;
	НастройкиСистемыЛокализация.ДополнитьИмяПравилОбменаПомощникВыгрузкиЗагрузкиМоделиМеждународногоУчета(ИмяПравилОбмена);
	Возврат ИмяПравилОбмена;
КонецФункции


Функция ЗначенияТехнологическихФункциональныхОпцийУТ() Экспорт
	
	ЗначенияОпций = Новый Структура();
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.УправлениеПредприятием.Имя, Ложь);
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.КомплекснаяАвтоматизация.Имя, Ложь);
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.УправлениеТорговлей.Имя, Истина);
	
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.ВедетсяУчетПостоянныхИВременныхРазницОбщая.Имя, Ложь);
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.ИспользоватьБюджетирование.Имя, Ложь);
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.ИспользоватьВнеоборотныеАктивы2_2.Имя, Ложь);
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.ИспользоватьВнеоборотныеАктивы2_4.Имя, Ложь);
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.ИспользоватьЗаполнениеРаздела7ДекларацииПоНДС.Имя, Ложь);
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.ИспользоватьМатериалыВЭксплуатацииКонтекст.Имя, Ложь);
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.ИспользоватьНачислениеЗарплатыУТ.Имя, Ложь);
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс.Имя, Ложь);
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.ИспользоватьСерииНоменклатурыПроизводство.Имя, Ложь);
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.ИспользоватьРеглУчет.Имя, Ложь);
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.ИспользоватьУведомленияОКонтролируемыхСделках.Имя, Ложь);
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.ИспользоватьУправлениеПроизводством.Имя, Ложь);
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.ИспользоватьУправлениеПроизводством2_2.Имя, Ложь);
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.УчетТМЦВЭксплуатацииУПКА.Имя, Ложь);
	ЗначенияОпций.Вставить(Метаданные.ФункциональныеОпции.УчетТМЦВЭксплуатацииWE.Имя, Ложь);
	
	Возврат ЗначенияОпций;
	
КонецФункции


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область КонстантыСлужебные

Функция ПроверитьСоответствиеЗначенийКонстант() Экспорт
	
	ТаблицаКонстант  = НастройкиСистемыПовтИсп.ПолучитьТаблицуЗависимостиКонстант();
	ЗначенияКонстант = Новый Структура;
	
	ТаблицаНесоответствия = Новый ТаблицаЗначений;
	ТаблицаНесоответствия.Колонки.Добавить("ИмяРодительскойКонстанты", Новый ОписаниеТипов("Строка"));
	ТаблицаНесоответствия.Колонки.Добавить("ИмяПодчиненнойКонстанты",  Новый ОписаниеТипов("Строка"));
	
	// Получим значения всех констант, родительских и подчиненных
	Для Каждого Строка Из ТаблицаКонстант Цикл
		Если НЕ ЗначенияКонстант.Свойство(Строка.ИмяРодительскойКонстанты) Тогда
			ЗначенияКонстант.Вставить(Строка.ИмяРодительскойКонстанты, Константы[Строка.ИмяРодительскойКонстанты].Получить());
		КонецЕсли;
		Если НЕ ЗначенияКонстант.Свойство(Строка.ИмяПодчиненнойКонстанты) Тогда
			ЗначенияКонстант.Вставить(Строка.ИмяПодчиненнойКонстанты, Константы[Строка.ИмяПодчиненнойКонстанты].Получить());
		КонецЕсли;
	КонецЦикла; 
	
	// Заполним несоответствия допустимых и фактических сочетаний значений констант
	Для Каждого Строка Из ТаблицаКонстант Цикл
		Если Строка.ЗначениеРодительскойКонстанты = ЗначенияКонстант[Строка.ИмяРодительскойКонстанты]
		 И Строка.ЗначениеПодчиненнойКонстанты <> ЗначенияКонстант[Строка.ИмяПодчиненнойКонстанты] Тогда
			СтрокаНесоответствия = ТаблицаНесоответствия.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНесоответствия, Строка);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаНесоответствия.Сортировать("ИмяРодительскойКонстанты, ИмяПодчиненнойКонстанты");
	
	Возврат ТаблицаНесоответствия;
	
КонецФункции

// Параметры:
// 	ТаблицаКонстант - см. НастройкиСистемы.ИнициализироватьТаблицуЗначенийКонстант
// 	ИмяРодительскойКонстанты - Строка -
// 	ЗначениеРодительскойКонстанты - Булево - Описание
// 	ИмяПодчиненнойКонстанты - Строка - Описание
// 	ЗначениеПодчиненнойКонстанты - Булево - Описание
Процедура ДобавитьСтрокуТаблицыЗависимостиКонстант(ТаблицаКонстант, ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты, ИмяПодчиненнойКонстанты, ЗначениеПодчиненнойКонстанты) Экспорт 
	
	НоваяСтрока = ТаблицаКонстант.Добавить();
	НоваяСтрока.ИмяРодительскойКонстанты 	  = ИмяРодительскойКонстанты;
	НоваяСтрока.ЗначениеРодительскойКонстанты = ЗначениеРодительскойКонстанты;
	НоваяСтрока.ИмяПодчиненнойКонстанты 	  = ИмяПодчиненнойКонстанты;
	НоваяСтрока.ЗначениеПодчиненнойКонстанты  = ЗначениеПодчиненнойКонстанты;
	
КонецПроцедуры

Процедура ДобавитьСтрокуИнвертируемыхКонстант(ТаблицаКонстант, ИмяРодительскойКонстанты, ИмяПодчиненнойКонстанты = "") Экспорт
	
	Если ИмяПодчиненнойКонстанты = "" Тогда
		ИмяПодчиненнойКонстанты = "Не" + ИмяРодительскойКонстанты;
	КонецЕсли;
	
	ДобавитьСтрокуТаблицыЗависимостиКонстант(ТаблицаКонстант,
		ИмяРодительскойКонстанты, Ложь,   ИмяПодчиненнойКонстанты, Истина);
	ДобавитьСтрокуТаблицыЗависимостиКонстант(ТаблицаКонстант,
		ИмяРодительскойКонстанты, Истина, ИмяПодчиненнойКонстанты, Ложь);
	
КонецПроцедуры

Функция ПолучитьСтруктуруРодительскихКонстантРекурсивно(СтруктураПодчиненныхКонстант, ТаблицаКонстант, ОбработанныеКонстанты) Экспорт
	
	Результат = Новый Структура;
	
	Для Каждого ИскомаяКонстанта Из СтруктураПодчиненныхКонстант Цикл
		
		РодительскиеКонстанты = ТаблицаКонстант.НайтиСтроки(
			Новый Структура("ИмяПодчиненнойКонстанты", ИскомаяКонстанта.Ключ));
		
		Для Каждого СтрокаРодителя Из РодительскиеКонстанты Цикл
			
			Если Результат.Свойство(СтрокаРодителя.ИмяРодительскойКонстанты)
			 ИЛИ ОбработанныеКонстанты.Свойство(СтрокаРодителя.ИмяРодительскойКонстанты)
			 ИЛИ СтруктураПодчиненныхКонстант.Свойство(СтрокаРодителя.ИмяРодительскойКонстанты) Тогда
				Продолжить;
			КонецЕсли;
			
			Результат.Вставить(СтрокаРодителя.ИмяРодительскойКонстанты);
			ОбработанныеКонстанты.Вставить(СтрокаРодителя.ИмяРодительскойКонстанты);
			
			РодителиРодителя = ПолучитьСтруктуруРодительскихКонстантРекурсивно(
				Новый Структура(СтрокаРодителя.ИмяРодительскойКонстанты),
				ТаблицаКонстант,
				ОбработанныеКонстанты);
			
			Для Каждого РодительРодителя Из РодителиРодителя Цикл
				Результат.Вставить(РодительРодителя.Ключ);
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСтруктуруПодчиненныхКонстантРекурсивно(ИмяРодительскойКонстанты, ТаблицаКонстант, ОбработанныеКонстанты) Экспорт
	
	Результат = Новый Структура;
	
	ПодчиненныеКонстанты = ТаблицаКонстант.НайтиСтроки(
		Новый Структура("ИмяРодительскойКонстанты", ИмяРодительскойКонстанты));
	
	Для Каждого СтрокаПодчиненного Из ПодчиненныеКонстанты Цикл
		
		Если Результат.Свойство(СтрокаПодчиненного.ИмяПодчиненнойКонстанты)
		 ИЛИ ОбработанныеКонстанты.Свойство(СтрокаПодчиненного.ИмяПодчиненнойКонстанты) Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.Вставить(СтрокаПодчиненного.ИмяПодчиненнойКонстанты);
		ОбработанныеКонстанты.Вставить(СтрокаПодчиненного.ИмяПодчиненнойКонстанты);
		
		ПодчиненныеПодчиненных = ПолучитьСтруктуруПодчиненныхКонстантРекурсивно(
			СтрокаПодчиненного.ИмяПодчиненнойКонстанты,
			ТаблицаКонстант,
			ОбработанныеКонстанты);
		
		Для Каждого ПодчиненныйПодчиненного Из ПодчиненныеПодчиненных Цикл
			Результат.Вставить(ПодчиненныйПодчиненного.Ключ);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Описание
// 
// Возвращаемое значение:
// 	ТаблицаЗначений - Описание:
// * ИмяРодительскойКонстанты - Строка -
// * ИмяПодчиненнойКонстанты - Строка -
// * ЗначениеРодительскойКонстанты - Произвольный - 
// * ЗначениеПодчиненнойКонстанты - Произвольный -
Функция ИнициализироватьТаблицуЗначенийКонстант() Экспорт
	
	Результат = Новый ТаблицаЗначений;
	
	Результат.Колонки.Добавить("ИмяРодительскойКонстанты", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ИмяПодчиненнойКонстанты",  Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ЗначениеРодительскойКонстанты");
	Результат.Колонки.Добавить("ЗначениеПодчиненнойКонстанты");
	
	Результат.Индексы.Добавить("ИмяРодительскойКонстанты");
	Результат.Индексы.Добавить("ИмяПодчиненнойКонстанты");
	
	Возврат Результат
	
КонецФункции

Процедура СинхронизироватьЗначенияПодчиненныхКонстант(ИмяКонстанты, ЗначениеКонстанты, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТипКонстанты	= ТипЗнч(ЗначениеКонстанты);
	ПримитивныеТипы = Новый ОписаниеТипов("Число,Строка,Дата,Булево,Неопределено");
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Синхронизировать "простые" зависимые константы
	Если ПримитивныеТипы.СодержитТип(ТипКонстанты)
	 ИЛИ ОбщегоНазначения.ЗначениеСсылочногоТипа(ЗначениеКонстанты) Тогда
		
		ПодчиненныеКонстанты = НастройкиСистемыПовтИсп.ПолучитьДопустимыеЗначенияПодчиненныхКонстант(ИмяКонстанты, ЗначениеКонстанты);
		
		Если ЗначениеЗаполнено(ПодчиненныеКонстанты) Тогда
			
			Для Каждого КлючИЗначение Из ПодчиненныеКонстанты Цикл
				УстановитьЗначениеКонстанты(Константы[КлючИЗначение.Ключ], КлючИЗначение.Значение);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Синхронизировать "сложные" зависимые константы
	
	Если ИмяКонстанты = "ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента"

	 ИЛИ ИмяКонстанты = "ИспользоватьЗаказыНаПеремещение"
	 ИЛИ ИмяКонстанты = "ИспользоватьЗаказыНаВнутреннееПотребление"
	 ИЛИ ИмяКонстанты = "ИспользоватьЗаказыНаСборку" Тогда
		
		ЗначениеПодчиненнойКонстанты =
			Константы.ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента.Получить()
			ИЛИ Константы.ИспользоватьЗаказыНаПеремещение.Получить()
			ИЛИ Константы.ИспользоватьЗаказыНаВнутреннееПотребление.Получить()
			ИЛИ Константы.ИспользоватьЗаказыНаСборку.Получить();
		
		
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьОбособленноеОбеспечениеЗаказов, ЗначениеПодчиненнойКонстанты И Константы.ИспользоватьОбособленноеОбеспечениеЗаказов.Получить());
		
		УстановитьЗначениеКонстанты(Константы.ИспользоватьЗаказыХотяБыОдногоВида, ЗначениеПодчиненнойКонстанты);
		
	КонецЕсли;
	
	
	Если ИмяКонстанты = "БазоваяВерсия" И ЗначениеКонстанты
		И Константы.ИспользоватьРасширенноеОбеспечениеПотребностей.Получить() Тогда
	
		УстановитьЗначениеКонстанты(Константы.ИспользоватьРасширенноеОбеспечениеПотребностей, Ложь);
	
	
	ИначеЕсли ИмяКонстанты = "ИспользоватьОбособленноеОбеспечениеЗаказов" Тогда
		
		ОбеспечениеСервер.ИспользоватьНазначенияБезЗаказаВычислитьИЗаписать();
		
	ИначеЕсли ИмяКонстанты = "ИспользоватьНазначенияБезЗаказа" Тогда
		
		ОбеспечениеСервер.НеИспользоватьНазначенияБезЗаказаВычислитьИЗаписатьИнверсией();
		
	ИначеЕсли ИмяКонстанты = "РазрешитьОбособлениеТоваровСверхПотребности" Тогда
		
		ОбеспечениеСервер.ИспользоватьУправлениеПеремещениемОбособленныхТоваровВычислитьИЗаписать();
		
	ИначеЕсли ИмяКонстанты = "ИспользоватьПеремещениеТоваров" Тогда
		
		ОбеспечениеСервер.ИспользоватьУправлениеПеремещениемОбособленныхТоваровВычислитьИЗаписать();
		
	ИначеЕсли ИмяКонстанты = "ИспользоватьЗаказыПоставщикам"
				Или ИмяКонстанты = "ИспользоватьЗаказыНаПеремещение"
				Или ИмяКонстанты = "ИспользоватьЗаказыНаСборку"
				Или ИмяКонстанты = "ИспользоватьПроизводство" Тогда
				
			ЗначениеИстинаДоступноДляКонстанты =
				Не СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
				И (Константы.ИспользоватьЗаказыПоставщикам.Получить()
					Или Константы.ИспользоватьЗаказыНаПеремещение.Получить()
					Или Константы.ИспользоватьЗаказыНаСборку.Получить()
					Или Константы.ИспользоватьПроизводство.Получить());
				
			Если Константы.ИспользоватьРасширенноеОбеспечениеПотребностей.Получить() Тогда
				
				Если Не ЗначениеИстинаДоступноДляКонстанты Тогда
					УстановитьЗначениеКонстанты(Константы.ИспользоватьРасширенноеОбеспечениеПотребностей, Ложь);
				КонецЕсли;
				
			Иначе
				
				Если Не Константы.ИспользоватьЗаказыПоставщикам.Получить() Тогда
					
					Если ЗначениеИстинаДоступноДляКонстанты Тогда
						УстановитьЗначениеКонстанты(Константы.ИспользоватьРасширенноеОбеспечениеПотребностей, Истина);
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			Если ИмяКонстанты = "ИспользоватьУправлениеПроизводством2_2" Тогда
				ОбеспечениеСервер.ИспользоватьУправлениеПеремещениемОбособленныхТоваровВычислитьИЗаписать();
			КонецЕсли;
			
	КонецЕсли;

	Если ИмяКонстанты = "ИспользоватьОплатуПлатежнымиКартами"
	 ИЛИ ИмяКонстанты = "ИспользоватьПодключаемоеОборудование" Тогда
		
		Если ИмяКонстанты = "ИспользоватьОплатуПлатежнымиКартами" Тогда
			ЗначениеПодчиненнойКонстанты = ЗначениеКонстанты И Константы.ИспользоватьПодключаемоеОборудование.Получить();
		Иначе
			ЗначениеПодчиненнойКонстанты = ЗначениеКонстанты И Константы.ИспользоватьОплатуПлатежнымиКартами.Получить();
		КонецЕсли;
		
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьПодключаемоеОборудованиеИОплатуПлатежнымиКартами, ЗначениеПодчиненнойКонстанты);
	 	
	ИначеЕсли ИмяКонстанты = "ИспользоватьНесколькоКасс"
	 	  ИЛИ ИмяКонстанты = "ИспользоватьНесколькоРасчетныхСчетов" Тогда
		
		Если ИмяКонстанты = "ИспользоватьНесколькоКасс" Тогда
			ЗначениеПодчиненнойКонстанты = ЗначениеКонстанты ИЛИ Константы.ИспользоватьНесколькоРасчетныхСчетов.Получить();
		Иначе
			ЗначениеПодчиненнойКонстанты = ЗначениеКонстанты ИЛИ Константы.ИспользоватьНесколькоКасс.Получить();
		КонецЕсли;
		
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьНесколькоРасчетныхСчетовКасс, ЗначениеПодчиненнойКонстанты);
			
	ИначеЕсли ИмяКонстанты = "ИспользоватьНесколькоВалют" Тогда
		
		Если НЕ ЗначениеКонстанты Тогда
			
			ЗначениеПодчиненнойКонстанты = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета();
			
			УстановитьЗначениеКонстанты(
				Константы.ВалютаУправленческогоУчета, 	  ЗначениеПодчиненнойКонстанты);
			УстановитьЗначениеКонстанты(
				Константы.БазоваяВалютаПоУмолчанию, ЗначениеПодчиненнойКонстанты);
		КонецЕсли;
		
	ИначеЕсли ИмяКонстанты = "ИспользоватьЗаказыКлиентов" 
		ИЛИ ИмяКонстанты = "ИспользоватьЗаявкиНаВозвратТоваровОтКлиентов" Тогда
		
		Если НЕ Константы.ИспользоватьЗаказыКлиентов.Получить() 
			И НЕ Константы.ИспользоватьЗаявкиНаВозвратТоваровОтКлиентов.Получить() Тогда
		
			УстановитьЗначениеКонстанты(
				Константы.ИспользоватьРасширенныеВозможностиЗаказаКлиента,   Ложь);
				
			КонецЕсли;
			
	ИначеЕсли ИмяКонстанты = "ИспользоватьРасширенныеВозможностиЗаказаКлиента" Тогда
		
		Если НЕ Константы.ИспользоватьРасширенныеВозможностиЗаказаКлиента.Получить() Тогда
		
			УстановитьЗначениеКонстанты(
				Константы.НеЗакрыватьЗаказыКлиентовБезПолнойОплаты,   Ложь);
			УстановитьЗначениеКонстанты(
				Константы.НеЗакрыватьЗаказыКлиентовБезПолнойОтгрузки, Ложь);
			
		КонецЕсли;
	ИначеЕсли ИмяКонстанты = "ИспользоватьСогласованиеЗаявокНаВозвратТоваровОтКлиентов"
	 ИЛИ ИмяКонстанты = "ИспользоватьСогласованиеЗаказовКлиентов"
	 ИЛИ ИмяКонстанты = "ИспользоватьСогласованиеСоглашенийСКлиентами" Тогда
		
		ИмяПодчиненнойКонстанты 	 = ПодчиненнаяКонстантаСогласования(ИмяКонстанты);
		ЗначениеПодчиненнойКонстанты = ЗначениеКонстанты;
		
		УстановитьЗначениеКонстанты(
			Константы[ИмяПодчиненнойКонстанты], ЗначениеПодчиненнойКонстанты);
			
	ИначеЕсли ИмяКонстанты = "ИспользоватьСделкиСКлиентами" Тогда
		
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьУправлениеСделками, ЗначениеКонстанты И Константы.ИспользоватьУправлениеСделками.Получить());
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьПервичныйСпрос, 	  ЗначениеКонстанты И Константы.ИспользоватьПервичныйСпрос.Получить());
		
	ИначеЕсли ИмяКонстанты = "ИспользоватьУправлениеСделками" Тогда
		
	УстановитьЗначениеКонстанты(
		Константы.ИспользоватьЗаказыКлиентов, 	  			   ЗначениеКонстанты ИЛИ Константы.ИспользоватьЗаказыКлиентов.Получить());
		
	ИначеЕсли ИмяКонстанты = "ДетализироватьЗаданияТорговымПредставителямПоНоменклатуре"
	 ИЛИ ИмяКонстанты = "ИспользованиеЗаданийТорговымПредставителям" Тогда
		
		Если ИмяКонстанты = "ДетализироватьЗаданияТорговымПредставителямПоНоменклатуре" Тогда
			ЗначениеПодчиненнойКонстанты = НЕ ЗначениеКонстанты
				И Константы.ИспользованиеЗаданийТорговымПредставителям.Получить() = Перечисления.ИспользованиеЗаданийТорговымПредставителям.ИспользуютсяДляУправленияТорговымиПредставителями;
		Иначе
			ЗначениеПодчиненнойКонстанты = НЕ Константы.ДетализироватьЗаданияТорговымПредставителямПоНоменклатуре.Получить()
				И ЗначениеКонстанты = Перечисления.ИспользованиеЗаданийТорговымПредставителям.ИспользуютсяДляУправленияТорговымиПредставителями;
		КонецЕсли;
		
		УстановитьЗначениеКонстанты(
			Константы.НеДетализироватьЗаданияТорговымПредставителямПоНоменклатуре, ЗначениеПодчиненнойКонстанты);
				
	ИначеЕсли ИмяКонстанты = "ИспользоватьРучныеСкидкиВПродажах"
		ИЛИ ИмяКонстанты = "ИспользоватьАвтоматическиеСкидкиВПродажах" Тогда
		
		Если НЕ Константы.ИспользоватьРучныеСкидкиВПродажах.Получить()
			И НЕ Константы.ИспользоватьАвтоматическиеСкидкиВПродажах.Получить() Тогда
		
			УстановитьЗначениеКонстанты(Константы.ВыбиратьВариантВыводаСкидокПриПечатиДокументовПродажи, Ложь);
			УстановитьЗначениеКонстанты(Константы.ОтображениеСкидокВПечатныхФормахДокументовПродажи, Перечисления.ВариантыВыводаСкидокВПечатныхФормах.НеВыводитьСкидки);
		КонецЕсли;
	ИначеЕсли ИмяКонстанты = "ИспользоватьСчетаНаОплатуКлиентам" Тогда
		
		ЗначениеПодчиненнойКонстанты = ?(НЕ ЗначениеКонстанты, Константы.ВыбиратьВариантВыводаСкидокПриПечатиДокументовПродажи.Получить(), Ложь);
		
		УстановитьЗначениеКонстанты(Константы.НеИспользоватьСчетаНаОплатуНеВыбиратьВариантВыводаСкидок, ?(НЕ ЗначениеКонстанты, НЕ ЗначениеПодчиненнойКонстанты, ЗначениеПодчиненнойКонстанты));
		УстановитьЗначениеКонстанты(Константы.НеИспользоватьСчетаНаОплатуВыбиратьВариантВыводаСкидок, ЗначениеПодчиненнойКонстанты);
	
	КонецЕсли;
	
	Если ИмяКонстанты = "ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента"
	 ИЛИ ИмяКонстанты = "ИспользоватьЗаказыНаПеремещение"
	 ИЛИ ИмяКонстанты = "ИспользоватьЗаказыНаВнутреннееПотребление"
	 ИЛИ ИмяКонстанты = "ИспользоватьЗаказыНаСборку" Тогда
		
		ЗначениеПодчиненнойКонстанты =
			Константы.ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента.Получить()
			ИЛИ Константы.ИспользоватьЗаказыНаПеремещение.Получить()
			ИЛИ Константы.ИспользоватьЗаказыНаВнутреннееПотребление.Получить()
			ИЛИ Константы.ИспользоватьЗаказыНаСборку.Получить();

		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьОбособленноеОбеспечениеЗаказов,
			ЗначениеПодчиненнойКонстанты
			И Константы.ИспользоватьОбособленноеОбеспечениеЗаказов.Получить());
			
	КонецЕсли;
	
	
	
	Если ИмяКонстанты = Метаданные.Константы.ИспользоватьКачествоТоваров.Имя
		Или ИмяКонстанты = Метаданные.Константы.ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи.Имя Тогда
		
		ИспользоватьКачествоТоваров = ЗначениеКонстанты;
		ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи = ЗначениеКонстанты;
		
		Если Не ИмяКонстанты = Метаданные.Константы.ИспользоватьКачествоТоваров.Имя Тогда
			ИспользоватьКачествоТоваров = Константы.ИспользоватьКачествоТоваров.Получить();
		КонецЕсли;
		
		
		Если Не ИмяКонстанты = Метаданные.Константы.ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи.Имя Тогда
			ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи =
				Константы.ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи.Получить();
		КонецЕсли;
	
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьПорчуТоваровУХранителей,
			ИспользоватьКачествоТоваров
			И (ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи
				Или Ложь));
		
	КонецЕсли;
	
	Если ИмяКонстанты = Метаданные.Константы.ИспользоватьКачествоТоваров.Имя
		Или ИмяКонстанты = Метаданные.Константы.ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи.Имя Тогда
		
		ИспользоватьКачествоТоваров = ЗначениеКонстанты;
		ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи = ЗначениеКонстанты;
		
		Если Не ИмяКонстанты = Метаданные.Константы.ИспользоватьКачествоТоваров.Имя Тогда
			ИспользоватьКачествоТоваров = Константы.ИспользоватьКачествоТоваров.Получить();
		КонецЕсли;
		
		
		Если Не ИмяКонстанты = Метаданные.Константы.ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи.Имя Тогда
			ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи =
				Константы.ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи.Получить();
		КонецЕсли;
	
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьПорчуТоваровУХранителей,
			ИспользоватьКачествоТоваров
			И (ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи
				Или Ложь));
		
	КонецЕсли;
	
	Если ИмяКонстанты = Метаданные.Константы.ИспользоватьИмпортныеЗакупки.Имя 
		ИЛИ ИмяКонстанты = Метаданные.Константы.ИспользоватьТоварыВПутиОтПоставщиков.Имя Тогда
		
		ИспользоватьИмпортныеЗакупки = Константы.ИспользоватьИмпортныеЗакупки.Получить();
		ИспользоватьТоварыВПутиОтПоставщиков = Константы.ИспользоватьТоварыВПутиОтПоставщиков.Получить();
		
		УстановитьЗначениеКонстанты(Константы.ИспользоватьИмпортныеЗакупкиТоваровВПути, 
			ИспользоватьИмпортныеЗакупки И ИспользоватьТоварыВПутиОтПоставщиков);
		
	КонецЕсли;
	
	Если ИмяКонстанты = "ИспользоватьПланированиеПродаж"
		ИЛИ ИмяКонстанты = "ИспользоватьПланированиеЗакупок"
		ИЛИ ИмяКонстанты = "ИспользоватьПланированиеСборкиРазборки"
		ИЛИ ИмяКонстанты = "ИспользоватьПланированиеВнутреннихПотреблений" Тогда
		
		ПланыПродаж =                Константы.ИспользоватьПланированиеПродаж.Получить();
		ПланыПродажПоКатегориям =    Константы.ИспользоватьПланированиеПродажПоКатегориям.Получить();
		ПланыЗакупок =               Константы.ИспользоватьПланированиеЗакупок.Получить();
		ПланыСборкиРазборки =        Константы.ИспользоватьПланированиеСборкиРазборки.Получить();
		ПланыВнутреннихПотреблений = Константы.ИспользоватьПланированиеВнутреннихПотреблений.Получить();
		
		Если Константы.УправлениеТорговлей.Получить()
			И (ПланыПродаж
			ИЛИ ПланыПродажПоКатегориям
			ИЛИ ПланыЗакупок
			ИЛИ ПланыСборкиРазборки
			ИЛИ ПланыВнутреннихПотреблений) Тогда
			
			УстановитьЗначениеКонстанты(Константы.ИспользоватьСбалансированностьПлановУТ, Истина);
			
		Иначе
			
			УстановитьЗначениеКонстанты(Константы.ИспользоватьСбалансированностьПлановУТ, Ложь);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяКонстанты = "ИспользуетсяЦенообразование25" Тогда

		УстановитьЗначениеКонстанты(Константы.ИспользоватьХарактеристикиНоменклатурыДляЦенообразования, 
									ЗначениеКонстанты И Константы.ИспользоватьХарактеристикиНоменклатуры.Получить());
		УстановитьЗначениеКонстанты(Константы.ИспользоватьСерииНоменклатурыДляЦенообразования, 	
									ЗначениеКонстанты И Константы.ИспользоватьСерииНоменклатуры.Получить());
		УстановитьЗначениеКонстанты(Константы.ИспользоватьУпаковкиНоменклатурыДляЦенообразования, 
									ЗначениеКонстанты И Константы.ИспользоватьУпаковкиНоменклатуры.Получить());
		
		Если Не Константы.ИспользуетсяЦенообразование25.Получить() Тогда
			УстановитьЗначениеКонстанты(Константы.ДатаПереходаНаЦенообразование25, Дата(1,1,1));
		КонецЕсли;
			
	ИначеЕсли ИмяКонстанты = "ИспользоватьХарактеристикиНоменклатуры" Тогда
		
		ЗначениеПодчиненнойКонстанты = ЗначениеКонстанты И Константы.ИспользуетсяЦенообразование25.Получить();
		УстановитьЗначениеКонстанты(Константы.ИспользоватьХарактеристикиНоменклатурыДляЦенообразования, ЗначениеПодчиненнойКонстанты);
		
	ИначеЕсли ИмяКонстанты = "ИспользоватьСерииНоменклатуры" Тогда
		
		ЗначениеПодчиненнойКонстанты = ЗначениеКонстанты И Константы.ИспользуетсяЦенообразование25.Получить();
		УстановитьЗначениеКонстанты(Константы.ИспользоватьСерииНоменклатурыДляЦенообразования, ЗначениеПодчиненнойКонстанты);
		
	ИначеЕсли ИмяКонстанты = "ИспользоватьУпаковкиНоменклатуры" Тогда
		
		ЗначениеПодчиненнойКонстанты = ЗначениеКонстанты И Константы.ИспользуетсяЦенообразование25.Получить();
		УстановитьЗначениеКонстанты(Константы.ИспользоватьУпаковкиНоменклатурыДляЦенообразования, ЗначениеПодчиненнойКонстанты);
		
	КонецЕсли;
	
	Если ИмяКонстанты = "ИспользованиеСоглашенийСКлиентами" Тогда
		
		СоглашениеСКлиентами = Константы.ИспользоватьСоглашенияСКлиентами.Получить();
		ТолькоКомиссионныеПродажи25 = Константы.ТолькоКомиссионныеПродажи25.Получить();
		ДоговорыСКлиентами = Константы.ИспользоватьДоговорыСКлиентами.Получить();
		
		Если Не ТолькоКомиссионныеПродажи25 И Не ДоговорыСКлиентами И Не СоглашениеСКлиентами Тогда
			УстановитьЗначениеКонстанты(Константы.ИспользоватьКомиссиюПриПродажах, Ложь);
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяКонстанты = Метаданные.Константы.ИспользоватьМногострановойУчет.Имя Тогда
		УстановитьЗначениеКонстанты(Константы.НеИспользоватьМногострановойУчет, НЕ ЗначениеКонстанты);
		Если ЗначениеКонстанты Тогда
			УстановитьЗначениеКонстанты(Константы.ВалютаРегламентированногоУчета, Неопределено);
		КонецЕсли;
	КонецЕсли;
			
	Если ИмяКонстанты = Метаданные.Константы.ВалютаРегламентированногоУчета.Имя
		И НЕ Константы.ИспользоватьМногострановойУчет.Получить() Тогда
			Константы.БазоваяВалютаПоУмолчанию.Установить(ЗначениеКонстанты);
	КонецЕсли;
	
	Если ИмяКонстанты = Метаданные.Константы.ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров.Имя Тогда
		НовоеЗначениеИспользованияДопустимогоОтклонения = ?(Константы.ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров.Получить() > 0, Истина, Ложь);
		УстановитьЗначениеКонстанты(Константы.ИспользоватьДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров, НовоеЗначениеИспользованияДопустимогоОтклонения);
	КонецЕсли;
	
	Если ИмяКонстанты = "ИспользоватьПередачиТоваровМеждуОрганизациями"
		Или Ложь Тогда
		
		ПередачиТоваров       = Константы.ИспользоватьПередачиТоваровМеждуОрганизациями.Получить();
		
		Если Не ПередачиТоваров
			И Истина Тогда
			Константы.ИспользоватьДоговорыМеждуОрганизациями.Установить(Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяКонстанты = "ИспользоватьПередачиТоваровМеждуОрганизациями"
		Или ИмяКонстанты = "НоваяАрхитектураВзаиморасчетов"
		Или ИмяКонстанты = "НеНоваяАрхитектураВзаиморасчетов" Тогда
		
		ПередачиТоваров       = Константы.ИспользоватьПередачиТоваровМеждуОрганизациями.Получить();
		НовыеВзаиморасчеты    = Константы.НоваяАрхитектураВзаиморасчетов.Получить();
		НеНовыеВзаиморасчеты  = Константы.НеНоваяАрхитектураВзаиморасчетов.Получить();
		
		Если НовыеВзаиморасчеты Тогда
			Константы.ИспользоватьОтчетРасчетыМеждуОрганизациями.Установить(Ложь);
		КонецЕсли;
		
		Если Не НовыеВзаиморасчеты Тогда
			Константы.ИспользоватьОтчетВедомостьРасчетовМеждуОрганизациями.Установить(Ложь);
		КонецЕсли;
		
		Если Не ПередачиТоваров
			И Истина Тогда
			Константы.ИспользоватьОтчетРасчетыМеждуОрганизациями.Установить(Ложь);
			Константы.ИспользоватьОтчетВедомостьРасчетовМеждуОрганизациями.Установить(Ложь);
		КонецЕсли;
		
		Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
			
			Если Не НовыеВзаиморасчеты Тогда
				Константы.ИспользоватьОтчетРасчетыМеждуОрганизациями.Установить(
					ПередачиТоваров
					Или Ложь);
			КонецЕсли;
			
			Если НовыеВзаиморасчеты Тогда
				Константы.ИспользоватьОтчетВедомостьРасчетовМеждуОрганизациями.Установить(
					ПередачиТоваров
					Или Ложь);
			КонецЕсли;
			
			Если ПередачиТоваров
				Или Ложь Тогда
				Константы.ИспользоватьОтчетРасчетыМеждуОрганизациями.Установить(НеНовыеВзаиморасчеты);
				Константы.ИспользоватьОтчетВедомостьРасчетовМеждуОрганизациями.Установить(НовыеВзаиморасчеты);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	НастройкиСистемыЛокализация.СинхронизироватьЗначенияПодчиненныхКонстант(ИмяКонстанты, ЗначениеКонстанты, Отказ);
	
КонецПроцедуры

Процедура УстановитьЗначениеКонстанты(МенеджерКонстанты, ЗначениеКонстанты) Экспорт
	
	Если МенеджерКонстанты.Получить() <> ЗначениеКонстанты Тогда
		МенеджерКонстанты.Установить(ЗначениеКонстанты);
	КонецЕсли;
	
КонецПроцедуры

Функция ПодчиненнаяКонстантаСогласования(ИмяКонстанты)
	
	СоответствиеКонстант = Новый Соответствие();
	
	СоответствиеКонстант.Вставить("ИспользоватьСогласованиеЗаявокНаВозвратТоваровОтКлиентов",
		"ИспользоватьВнутреннееСогласованиеЗаявокНаВозвратТоваровОтКлиентов");
	СоответствиеКонстант.Вставить("ИспользоватьСогласованиеЗаказовКлиентов",
		"ИспользоватьВнутреннееСогласованиеЗаказовКлиентов");
	СоответствиеКонстант.Вставить("ИспользоватьСогласованиеСоглашенийСКлиентами",
		"ИспользоватьВнутреннееСогласованиеСоглашенийСКлиентами");
		
	Возврат СоответствиеКонстант.Получить(ИмяКонстанты);
КонецФункции

#КонецОбласти

#КонецОбласти
