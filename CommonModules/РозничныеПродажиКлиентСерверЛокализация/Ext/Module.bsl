﻿
#Область ПрограммныйИнтерфейс

#Область ФискальныеОперации

// Дополняет колллекцию доступных видов оплат для вида документа
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - 
//  ДоступныеВидыОплаты - Структура -
//
Процедура ДополнитьДоступныеВидыОплаты(Форма, ДоступныеВидыОплаты) Экспорт
	
	//++ Локализация
	Если ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.ВозвратПодарочныхСертификатов") 
		Или ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.РеализацияПодарочныхСертификатов") Тогда
			
		ДоступныеВидыОплаты.Вставить("СБП", Форма.ИспользоватьОплатуСБП);

	ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.ЧекККМ") 
		Или ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.ЧекККМВозврат") Тогда
			
		ЭтоОплатаЭСФСС = (Форма.ИспользоватьОплатуЭСФСС
						И Форма.ЭквайринговыеТерминалы.Количество() > 0);
		ДоступныеВидыОплаты.Вставить("ЭСФСС", ЭтоОплатаЭСФСС);
		ДоступныеВидыОплаты.Вставить("СБП", Форма.ИспользоватьОплатуСБП);
		
	ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.ОперацияПоПлатежнойКарте") 
		И Форма.Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту") Тогда
		
		ЭтоОплатаСБП = (Форма.СпособПроведенияПлатежа = ПредопределенноеЗначение("Перечисление.СпособыПроведенияПлатежей.СистемаБыстрыхПлатежей"));
		ДоступныеВидыОплаты.Вставить("СБП", ЭтоОплатаСБП);
	
	КонецЕсли;
	//-- Локализация
	
КонецПроцедуры

//++ Локализация

// Возвращает сумму оплаты СБП по документу
// 
// Параметры:
//  ОплатыПлатежнойКартой - ДанныеФормыКоллекция, ТаблицаЗначений, ТабличнаяЧасть - Оплаты платежной картой:
//  * ВидОплаты - ПеречислениеСсылка.ТипыПлатежнойСистемыККТ -
//  * Сумма - Число - 
//  * СтатусОплатыСБП - ПеречислениеСсылка.ТипыСтатусовОплатыСБП - 
//  ТолькоОплатаВыполнена - Булево - Истина - Выполнена
// 
// Возвращаемое значение:
//  Число - сумма оплаты СБП по документу
//
Функция СуммаОплатыСБППоДокументу(ОплатыПлатежнойКартой, ТолькоОплатаВыполнена = Ложь) Экспорт
	
	СуммаОплатыСБП = 0;
	
	Для Каждого СтрокаТЗ Из ОплатыПлатежнойКартой Цикл
		
		Если СтрокаТЗ.ВидОплаты = ПредопределенноеЗначение("Перечисление.ТипыПлатежнойСистемыККТ.СистемаБыстрыхПлатежей") Тогда
			
			Если ТолькоОплатаВыполнена И СтрокаТЗ.СтатусОплатыСБП = ПредопределенноеЗначение("Перечисление.ТипыСтатусовОплатыСБП.Выполнена")
				ИЛИ Не ТолькоОплатаВыполнена Тогда
				
				СуммаОплатыСБП = СуммаОплатыСБП + СтрокаТЗ.Сумма;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СуммаОплатыСБП;
	
КонецФункции

// Возвращает массив строк оплаты СБП по документу
// 
// Параметры:
//  ОплатаПлатежнымиКартами - ДанныеФормыКоллекция, ТаблицаЗначений, ТабличнаяЧасть - Оплаты платежной картой:
//  * ВидОплаты - ПеречислениеСсылка.ТипыПлатежнойСистемыККТ -
//  * СтатусОплатыСБП - ПеречислениеСсылка.ТипыСтатусовОплатыСБП - 
//  ТолькоОплатаВыполнена - Булево - Истина - Выполнена
// 
// Возвращаемое значение:
//  Число - сумма оплаты СБП по документу
//
Функция СтрокиОплатыСБП(ОплатаПлатежнымиКартами, ТолькоОплатаВыполнена = Ложь) Экспорт
	
	ОтборОплатыСБП = Новый Структура("ВидОплаты", ПредопределенноеЗначение("Перечисление.ТипыПлатежнойСистемыККТ.СистемаБыстрыхПлатежей"));
	Если ТолькоОплатаВыполнена Тогда
		ОтборОплатыСБП.Вставить("СтатусОплатыСБП", ПредопределенноеЗначение("Перечисление.ТипыСтатусовОплатыСБП.Выполнена"));
	КонецЕсли;
	
	Возврат ОплатаПлатежнымиКартами.НайтиСтроки(ОтборОплатыСБП);
	
КонецФункции

// Возвращает структуру данных используемых для для возврата по документу оплаты СБП.
// 
// Возвращаемое значение:
//  Структура:
//   *ОснованиеПлатежа - ДокументСсылка - 
//   *Партнер - СправочникСсылка.Партнеры -
//   *Сумма - Число - 
//
Функция ДанныеДляВозвратаПоДокументуОплатыСБП() Экспорт

	Результат = Новый Структура;
	Результат.Вставить("ОснованиеПлатежа", Неопределено);
	Результат.Вставить("Партнер", Неопределено);
	Результат.Вставить("Сумма", 0);
	
	Возврат Результат;	
КонецФункции

//-- Локализация

#КонецОбласти

#КонецОбласти
