﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ВМагазинеПоддерживаетсяСборкаЗаказов", ВМагазинеПоддерживаетсяСборкаЗаказов);
	Параметры.Свойство("ВМагазинеПоддерживаетсяДоставкаСвоимиКурьерами", ВМагазинеПоддерживаетсяДоставкаСвоимиКурьерами);
	Параметры.Свойство("СпособСозданияРеализацииПриСборкеЗаказов", СпособСозданияРеализацииПриСборкеЗаказов);
	Параметры.Свойство("СпособФискализацииПриДоставке", СпособФискализацииПриДоставке);
	Параметры.Свойство("СборкаИДоставкаВыполняетсяОднимСотрудником", СборкаИДоставкаВыполняетсяОднимСотрудником);
	Параметры.Свойство("КурьерыМогутНазначатьСебеЗаказы", КурьерыМогутНазначатьСебеЗаказы);
	Параметры.Свойство("СборщикиМогутНазначатьСебеЗаказы", СборщикиМогутНазначатьСебеЗаказы);
	Параметры.Свойство("НормативныйСрокДоставкиЗаказов", НормативныйСрокДоставкиЗаказов);
	Параметры.Свойство("КурьерыИспользуютЭквайринговыеТерминалы", КурьерыИспользуютЭквайринговыеТерминалы);
	Параметры.Свойство("КурьерыИспользуютАвтономныеККТ", КурьерыИспользуютАвтономныеККТ);
	Параметры.Свойство("ДатаНачалаСборкиЗаказов", ДатаНачалаСборкиЗаказов);
	Параметры.Свойство("ДатаНачалаДоставкиСвоимиКурьерами", ДатаНачалаДоставкиСвоимиКурьерами);
	Параметры.Свойство("ГруппировкаТоваров", ГруппировкаТоваров);
	Параметры.Свойство("РежимФормы", РежимФормы);
	
	ОбъектФормы = Неопределено;//СправочникОбъект
	Если Параметры.Свойство("Объект", ОбъектФормы) Тогда
		ЭтоНовый = ОбъектФормы.Ссылка.Пустая();
		ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма, КоманднаяПанель, , ОбъектФормы);
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	УстановитьДоступностьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если СохранитьПараметры
		И Не ЗавершениеРаботы Тогда
	
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("ВМагазинеПоддерживаетсяСборкаЗаказов", ВМагазинеПоддерживаетсяСборкаЗаказов);
		СтруктураПараметров.Вставить("ВМагазинеПоддерживаетсяДоставкаСвоимиКурьерами", ВМагазинеПоддерживаетсяДоставкаСвоимиКурьерами);
		СтруктураПараметров.Вставить("СпособСозданияРеализацииПриСборкеЗаказов", СпособСозданияРеализацииПриСборкеЗаказов);
		СтруктураПараметров.Вставить("СпособФискализацииПриДоставке", СпособФискализацииПриДоставке);
		СтруктураПараметров.Вставить("СборкаИДоставкаВыполняетсяОднимСотрудником", СборкаИДоставкаВыполняетсяОднимСотрудником);
		СтруктураПараметров.Вставить("КурьерыМогутНазначатьСебеЗаказы", КурьерыМогутНазначатьСебеЗаказы);
		СтруктураПараметров.Вставить("СборщикиМогутНазначатьСебеЗаказы", СборщикиМогутНазначатьСебеЗаказы);
		СтруктураПараметров.Вставить("НормативныйСрокДоставкиЗаказов", НормативныйСрокДоставкиЗаказов);
		СтруктураПараметров.Вставить("КурьерыИспользуютЭквайринговыеТерминалы", КурьерыИспользуютЭквайринговыеТерминалы);
		СтруктураПараметров.Вставить("КурьерыИспользуютАвтономныеККТ", КурьерыИспользуютАвтономныеККТ);
		СтруктураПараметров.Вставить("ДатаНачалаСборкиЗаказов", ДатаНачалаСборкиЗаказов);
		СтруктураПараметров.Вставить("ДатаНачалаДоставкиСвоимиКурьерами", ДатаНачалаДоставкиСвоимиКурьерами);
		СтруктураПараметров.Вставить("ГруппировкаТоваров", ГруппировкаТоваров);

		ОповеститьОВыборе(СтруктураПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗакрытьФормуПринудительно
		И (Модифицированность И Не СохранитьПараметры) Тогда
		
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
			ТекстПредупреждения = НСтр("ru = 'Настройка будет прервана.'");
			Возврат;
		КонецЕсли;
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить("Закрыть", НСтр("ru = 'Закрыть'"));
		СписокКнопок.Добавить("НеЗакрывать", НСтр("ru = 'Не закрывать'"));
		
		ДополнительныеПараметры = Новый Структура;
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПоказатьВопросПередЗакрытиемЗавершение", ЭтотОбъект, ДополнительныеПараметры),
			НСтр("ru = 'Реквизиты были изменены. Закрыть без сохранения реквизитов?'"),
			СписокКнопок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросПередЗакрытиемЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = "Закрыть" Тогда
		ЗакрытьФормуПринудительно = Истина;
		Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВМагазинеПоддерживаетсяСборкаЗаказовПриИзменении(Элемент)
	
	Элементы.ГруппаНастройкиСборкиОсновная.Доступность = ВМагазинеПоддерживаетсяСборкаЗаказов;
	Элементы.ДатаНачалаСборкиЗаказов.Доступность = ВМагазинеПоддерживаетсяСборкаЗаказов;
	
	Если Не ВМагазинеПоддерживаетсяСборкаЗаказов Тогда
		СборщикиМогутНазначатьСебеЗаказы = Ложь;
		СборкаИДоставкаВыполняетсяОднимСотрудником = Ложь;
		СоздаватьРеализациюАвтоматическиПослеСборки = Ложь;
		ДатаНачалаСборкиЗаказов = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВМагазинеПоддерживаетсяДоставкаСвоимиКурьерамиПриИзменении(Элемент)
	
	Элементы.ГруппаНастройкиДоставкиОсновная.Доступность = ВМагазинеПоддерживаетсяДоставкаСвоимиКурьерами;
	Элементы.ДатаНачалаДоставкиСвоимиКурьерами.Доступность = ВМагазинеПоддерживаетсяДоставкаСвоимиКурьерами;
	
	Если Не ВМагазинеПоддерживаетсяДоставкаСвоимиКурьерами Тогда
		КурьерыМогутНазначатьСебеЗаказы = Ложь;
		КурьерыИспользуютАвтономныеККТ = Ложь;
		КурьерыИспользуютЭквайринговыеТерминалы = Ложь;
		НормативныйСрокДоставкиЗаказов = 0;
		ДатаНачалаДоставкиСвоимиКурьерами = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздаватьРеализациюАвтоматическиПослеСборкиПриИзменении(Элемент)
	
	СпособСозданияРеализацииПриСборкеЗаказов = СпособСозданияРеализацииПриСборкеЗаказов(СоздаватьРеализациюАвтоматическиПослеСборки);
	
КонецПроцедуры

&НаКлиенте
Процедура НормативныйСрокДоставкиЗаказовВЧасахПриИзменении(Элемент)
	
	НормативныйСрокДоставкиЗаказов = НормативныйСрокДоставкиЗаказовВЧасах*60;
	
КонецПроцедуры

&НаКлиенте
Процедура СпособФискализацииПриДоставкеПриИзменении(Элемент)

	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если НЕ ЭтоНовый Тогда
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("РежимФормы", РежимФормы);
		
		ОткрытьФорму("Обработка.НастройкиСбораЗаказовИКурьерскойДоставки.Форма.РазблокированиеРеквизитов",ПараметрыФормы,,,,, 
			Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
        
        ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	СохранитьПараметры = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	СохранитьПараметры = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьДоступностьВидимость()
	
	Заголовок = ?(РежимФормы = 2,
				НСтр("ru='Настройки магазина'"),
				НСтр("ru='Настройки формата магазина'"));
	
	ИспользоватьУправлениеДоставкой = ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеДоставкой");
	
	СоздаватьРеализациюАвтоматическиПослеСборки = (СпособСозданияРеализацииПриСборкеЗаказов 
		= Перечисления.СпособыСозданияРеализацииПриСборкеЗаказов.АвтоматическиПослеСборки);
		
	НормативныйСрокДоставкиЗаказовВЧасах = НормативныйСрокДоставкиЗаказов/60;
	
	Если Не ЗначениеЗаполнено(СпособФискализацииПриДоставке) Тогда
		СпособФискализацииПриДоставке = Перечисления.СпособыФискализацииПриДоставке.ВМоментОформленияРеализации;
	КонецЕсли;
	
	Элементы.ГруппаДоставка.Видимость = ИспользоватьУправлениеДоставкой;
		
	Элементы.ГруппаНастройкиСборкиОсновная.Доступность = ВМагазинеПоддерживаетсяСборкаЗаказов;
	Элементы.ДатаНачалаСборкиЗаказов.Доступность = ВМагазинеПоддерживаетсяСборкаЗаказов;
	Элементы.ГруппаНастройкиДоставкиОсновная.Доступность = ВМагазинеПоддерживаетсяДоставкаСвоимиКурьерами;
	Элементы.ДатаНачалаДоставкиСвоимиКурьерами.Доступность = ВМагазинеПоддерживаетсяДоставкаСвоимиКурьерами;
	
	Элементы.ДатаНачалаСборкиЗаказов.Видимость = (РежимФормы = 2);
	Элементы.ДатаНачалаДоставкиСвоимиКурьерами.Видимость = (РежимФормы = 2);
	
	Элементы.ГруппировкаТоваров.СписокВыбора.Добавить("Родитель", НСтр("ru='Группа списка'"));
	Элементы.ГруппировкаТоваров.СписокВыбора.Добавить("ВидНоменклатуры", НСтр("ru='Вид номенклатуры'"));
	Элементы.ГруппировкаТоваров.СписокВыбора.Добавить("ГруппаДоступа", НСтр("ru='Группа доступа'"));
	Элементы.ГруппировкаТоваров.СписокВыбора.Добавить("Марка", НСтр("ru='Марка (бренд)'"));
	Элементы.ГруппировкаТоваров.СписокВыбора.Добавить("Производитель", НСтр("ru='Производитель'"));
	Элементы.ГруппировкаТоваров.СписокВыбора.Добавить("ГруппаФинансовогоУчета", НСтр("ru='Группа настроек фин. учета'"));
	Элементы.ГруппировкаТоваров.СписокВыбора.Добавить("СкладскаяГруппа", НСтр("ru='Складская группа'"));
	Элементы.ГруппировкаТоваров.СписокВыбора.Добавить("ТоварнаяКатегория", НСтр("ru='Товарная категория'"));
	Элементы.ГруппировкаТоваров.СписокВыбора.Добавить("КоллекцияНоменклатуры", НСтр("ru='Коллекция (сезон)'"));
	Элементы.ГруппировкаТоваров.СписокВыбора.Добавить("СезоннаяГруппа", НСтр("ru='Сезонная группа'"));
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СпособСозданияРеализацииПриСборкеЗаказов(СоздаватьРеализациюАвтоматическиПослеСборки)
	
	Результат = ?(СоздаватьРеализациюАвтоматическиПослеСборки,
		Перечисления.СпособыСозданияРеализацииПриСборкеЗаказов.АвтоматическиПослеСборки,
		Перечисления.СпособыСозданияРеализацииПриСборкеЗаказов.ВручнуюОператором);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
